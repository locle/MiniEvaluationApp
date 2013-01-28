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

typedef void (^LoadBlock)();

@interface MEStaffViewController ()

@property (nonatomic, strong) NSDictionary *employeeDictionary;
@property (nonatomic, strong) NSDictionary *storedVisitCount;
@property (nonatomic, strong) MEEmployee *highestVisitedEmployee;
@property (readwrite, copy) LoadBlock loadStaffList;

@end

NSString* const kVisitCountKey = @"visitCount";

@implementation MEStaffViewController

- (void)setEmployeeDictionary:(NSDictionary *)employeeDictionary {
    _employeeDictionary = employeeDictionary;

    for (MEEmployee *storedEmployee in self.storedVisitCount.allValues) {
        MEEmployee *loaddedEmployee = [self.employeeDictionary objectForKey:storedEmployee.userName];
        if (loaddedEmployee) {
            loaddedEmployee.visitCount = storedEmployee.visitCount;
        }
    }
    
    self.highestVisitedEmployee = [MEEmployee highestVisitedEmployeeFromDataArray:self.employeeDictionary.allValues];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.storedVisitCount = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kVisitCountKey]];
    
    //Use 3rd party PullToRefresh
//    __weak MEStaffViewController *weakSelf = self;
//    void (^loadBlock)(void) = ^(void) {
//        
//            [[MEStaffAPIClient sharedInstance] loadEmployeeListWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
//                id obj = [response objectFromJSONData];
//                weakSelf.employeeDictionary = [MEEmployee employeeListFromDataArray:obj];
//                [weakSelf.tableView.pullToRefreshView stopAnimating];
//                [weakSelf.tableView reloadData];
//            }
//                                                                   failure:^(AFHTTPRequestOperation  *operation, NSError *error) {
//                                                                       DLog(@"%@",error.description);
//                                                                   }];
//    };
//    
//    loadBlock();
//    
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        dispatch_async(dispatch_get_main_queue(), loadBlock);
//    }];
    
    
    //Use native pull to refresh
    __weak MEStaffViewController *weakSelf = self;
    self.loadStaffList = ^{
        [[MEStaffAPIClient sharedInstance] loadEmployeeListWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
            id obj = [response objectFromJSONData];
            weakSelf.employeeDictionary = [MEEmployee employeeListFromDataArray:obj];
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [weakSelf.tableView reloadData];
            [weakSelf.refreshControl endRefreshing];
        }
                                                               failure:^(AFHTTPRequestOperation  *operation, NSError *error) {
                                                                   DLog(@"%@",error.description);
                                                               }];
    };
    
    self.loadStaffList();
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

-(void)refresh {
    self.loadStaffList();
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
        cell.title.textColor = [UIColor orange1];
    } else {
        cell.title.textColor = [UIColor blue1];
    }
    
//    for ( NSString *familyName in [UIFont familyNames] ) { NSLog(@"Family %@", familyName); NSLog(@"Names = %@", [UIFont fontNamesForFamilyName:familyName]); } 
    cell.subTitle.font = [UIFont meFontOfSize:10];
    cell.subTitle.textColor = [UIColor gray1];
    cell.subTitle.text = employee.role;
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
    cell.backgroundColor = (indexPath.row % 2) ? [UIColor gray2] : [UIColor gray3];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MEStaffDetailViewController *destinationVC = segue.destinationViewController;
    MEEmployee *employee = [self.employeeDictionary.allValues objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    employee.visitCount = [NSNumber numberWithInt:employee.visitCount.intValue
 + 1];
    if (employee.visitCount.intValue > self.highestVisitedEmployee.visitCount.intValue) {
        self.highestVisitedEmployee = employee;
        [self.tableView reloadData];
    }
    destinationVC.employee = employee;
    MELeftImageSubtitleListCell *cell = (MELeftImageSubtitleListCell *)[self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
    destinationVC.loadedAvatar = cell.leftImage.image;

}



@end
