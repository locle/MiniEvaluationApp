//
//  MESecondViewController.m
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffViewController.h"
#import "JSONKit.h"
#import "MEStaffAPIClient.h"
#import "MEEmployee.h"
#import "MEStaffDetailViewController.h"
#import "MELeftImageSubtitleListCell.h"
#import "AFNetworking.h"
#import "SVPullToRefresh.h"

@interface MEStaffViewController ()

@property (nonatomic, strong) NSDictionary *employeeDictionary;
@property (nonatomic, strong) MEEmployee *highestVisitedEmployee;
@end

NSString* const kVisitCountKey = @"visitCount";

@implementation MEStaffViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    __weak MEStaffViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [[MEStaffAPIClient sharedInstance] loadEmployeeListWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
                id obj = [response objectFromJSONData];
                weakSelf.employeeDictionary = [MEEmployee employeeListFromDataArray:obj];
                
                NSDictionary *storedCountCount = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kVisitCountKey]];
                for (MEEmployee *storedEmployee in storedCountCount.allValues) {
                    MEEmployee *loaddedEmployee = [weakSelf.employeeDictionary objectForKey:storedEmployee.userName];
                    if (loaddedEmployee) {
                        loaddedEmployee.visitCount = storedEmployee.visitCount;
                    }
                }
                [weakSelf.tableView.pullToRefreshView stopAnimating];
                
                self.highestVisitedEmployee = [MEEmployee highestVisitedEmployeeFromDataArray:self.employeeDictionary.allValues];
                [weakSelf.tableView reloadData];
            }
                                                                   failure:^(AFHTTPRequestOperation  *operation, NSError *error) {
                                                                       NSLog(@"%@",error.description);
                                                                   }];
            });
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    // Save data before close the app
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.employeeDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kVisitCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.employeeDictionary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MELeftImageSubtitleListCell";
    MELeftImageSubtitleListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[MELeftImageSubtitleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MELeftImageSubtitleListCell"];
    }
    // Configure the cell...
    
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    MEEmployee *employee = [self.employeeDictionary.allValues objectAtIndex:indexPath.row];
    cell.title.text = employee.name;
    cell.subTitle.text = employee.userName;
    if (employee.imageLink) {
        [cell.leftImage setImageWithURL:[NSURL URLWithString:employee.imageLink]];
    }
    if ([employee isEqual:self.highestVisitedEmployee]) {
        cell.highestVisitedMark.image = [UIImage imageNamed:@"icon_star.png"];
        NSLog(@"%g", employee.visitCount.doubleValue);
    } else {
        cell.highestVisitedMark.image = nil;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MEStaffDetailViewController *destinationVC = segue.destinationViewController;
    MEEmployee *employee = [self.employeeDictionary.allValues objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    employee.visitCount = [NSNumber numberWithInt:employee.visitCount.intValue
 + 1];
    destinationVC.employee = employee;
    MELeftImageSubtitleListCell *cell = (MELeftImageSubtitleListCell *)[self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
    destinationVC.loadedAvatar = cell.leftImage.image;

}



@end
