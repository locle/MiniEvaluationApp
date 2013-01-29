//
//  MESecondViewController.m
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffViewController.h"
#import "MEStaffAPIClient.h"


#import "MEStaffDetailViewController.h"
#import "MEEmployeeTableCell.h"


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
    
    self.staffTableView.delegate = self;
    self.staffTableView.dataSource = self;
    
    //Use 3rd party PullToRefresh
    __weak MEStaffViewController *weakSelf = self;
    void (^loadBlock)(void) = ^(void) {
        
            [[MEStaffAPIClient sharedInstance] loadEmployeeListWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
                id obj = [response objectFromJSONData];
                weakSelf.employeeDictionary = [MEEmployee employeeListFromDataArray:obj];
                [weakSelf.staffTableView.pullToRefreshView stopAnimating];
                [weakSelf.staffTableView reloadData];
            }
                                                                   failure:^(AFHTTPRequestOperation  *operation, NSError *error) {
                                                                       DLog(@"%@",error.description);
                                                                   }];
    };
    
    loadBlock();
    
    [self.staffTableView addPullToRefreshWithActionHandler:^{
        dispatch_async(dispatch_get_main_queue(), loadBlock);
    }];
    
    //Use native pull to refresh
//    __weak MEStaffViewController *weakSelf = self;
//    self.loadStaffList = ^{
//        [[MEStaffAPIClient sharedInstance] loadEmployeeListWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
//            id obj = [response objectFromJSONData];
//            weakSelf.employeeDictionary = [MEEmployee employeeListFromDataArray:obj];
//            [weakSelf.staffTableView.pullToRefreshView stopAnimating];
//            [weakSelf.staffTableView reloadData];
//            [weakSelf.refreshControl endRefreshing];
//        }
//                                                               failure:^(AFHTTPRequestOperation  *operation, NSError *error) {
//                                                                   DLog(@"%@",error.description);
//                                                               }];
//    };
//    
//    self.loadStaffList();
//    
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self action:@selector(refresh)
//             forControlEvents:UIControlEventValueChanged];
//    self.refreshControl = refreshControl;
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
    MEEmployeeTableCell *cell = [self.staffTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[MEEmployeeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MELeftImageSubtitleListCell"];
    }
    // Configure the cell...
    MEEmployee *employee = [self.employeeDictionary.allValues objectAtIndex:indexPath.row];
    [cell setUpWithEmployee:employee
                atIndexPath:indexPath
   isHighestVisitedEmployee:[employee isEqual:self.highestVisitedEmployee]
                  andTarget:nil];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MEStaffDetailViewController *destinationVC = segue.destinationViewController;
    MEEmployee *employee = [self.employeeDictionary.allValues objectAtIndex:self.staffTableView.indexPathForSelectedRow.row];
    employee.visitCount = [NSNumber numberWithInt:employee.visitCount.intValue
 + 1];
    if (employee.visitCount.intValue > self.highestVisitedEmployee.visitCount.intValue) {
        self.highestVisitedEmployee = employee;
        [self.staffTableView reloadData];
    }
    destinationVC.employee = employee;
    MEEmployeeTableCell *cell = (MEEmployeeTableCell *)[self.staffTableView cellForRowAtIndexPath:self.staffTableView.indexPathForSelectedRow];
    destinationVC.loadedAvatar = cell.leftImage.image;

}



@end
