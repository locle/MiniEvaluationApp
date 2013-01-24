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
#import <QuartzCore/QuartzCore.h>

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
                                                                       DLog(@"%@",error.description);
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
    if ([employee.gender isEqualToString:@"female"]) {
        cell.title.textColor = [UIColor colorWithRed:40.0/255.0 green:160.0/255.0 blue:180.0/255.0 alpha:1.0];
    } else {
        cell.title.textColor = [UIColor colorWithRed:255.0/255.0 green:166.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
    
    cell.subTitle.text = employee.userName;
    [cell.leftImage setImageWithURL:[NSURL URLWithString:employee.imageLink] placeholderImage:[UIImage imageNamed:@"icon_profile.png"]];
    cell.leftImage.layer.cornerRadius = cell.leftImage.frame.size.height / 2;
    cell.leftImage.clipsToBounds = YES;
    
    
    if ([employee isEqual:self.highestVisitedEmployee]) {
        cell.highestVisitedMark.image = [UIImage imageNamed:@"icon_star.png"];
    } else {
        cell.highestVisitedMark.image = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = (indexPath.row % 2) ? [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0] : [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
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
