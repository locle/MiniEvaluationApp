//
//  MEStaffDetailViewController.m
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffDetailViewController.h"
#import "MELeftImageRightDetailCell.h"
#import <AddressBook/AddressBook.h>

#define CELL_PADDING 32
#define MAX_HEIGHT 1000

@interface MEStaffDetailViewController ()

@property (nonatomic) int numOfRows;
@property (nonatomic, strong) NSArray *cellHeightArray;

@end

@implementation MEStaffDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.title = self.employee.name;
    
    self.navigationController.delegate = self;
    self.numOfRows = 0;
    
    
    MELeftImageRightDetailCell *avatarAndRoleCell = [self.tableView dequeueReusableCellWithIdentifier:@"AvatarAndRoleCell"];
    MELeftImageRightDetailCell *emailCell = [self.tableView dequeueReusableCellWithIdentifier:@"EmailCell"];
    NSMutableArray *mutableHeightArray = [NSMutableArray arrayWithCapacity:5];
    
    UIFont *font = avatarAndRoleCell.rightDetail.font;
    double width = avatarAndRoleCell.rightDetail.frame.size.width;
    
    // Role ana Avatar row
    double calculatedHeight = [self.employee.role sizeWithFont:font constrainedToSize:CGSizeMake(width, MAX_HEIGHT)].height + CELL_PADDING;
    if (calculatedHeight < avatarAndRoleCell.frame.size.height) {
        calculatedHeight = avatarAndRoleCell.frame.size.height;
    }
    [mutableHeightArray addObject:[NSNumber numberWithDouble:calculatedHeight]];
    
    //Email row
    [mutableHeightArray addObject:[NSNumber numberWithDouble:emailCell.frame.size.height]];
    
    //Contact row
    [mutableHeightArray addObject:[NSNumber numberWithDouble:emailCell.frame.size.height]];
    
    //Like row
    calculatedHeight = [self.employee.like sizeWithFont:font constrainedToSize:CGSizeMake(width, MAX_HEIGHT)].height + CELL_PADDING;
    if (calculatedHeight < emailCell.frame.size.height) {
        calculatedHeight = emailCell.frame.size.height;
    }
    [mutableHeightArray addObject:[NSNumber numberWithDouble:calculatedHeight]];
    
    //Dislike row
    calculatedHeight = [self.employee.dislike sizeWithFont:font constrainedToSize:CGSizeMake(width, MAX_HEIGHT)].height + CELL_PADDING;
    if (calculatedHeight < emailCell.frame.size.height) {
        calculatedHeight = emailCell.frame.size.height;
    }
    [mutableHeightArray addObject:[NSNumber numberWithDouble:calculatedHeight]];
    
    
    self.cellHeightArray = [mutableHeightArray copy];
    
    
    //Set custom back bar item for UINavigation Controller
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backButtonImage = [UIImage imageNamed:@"icon_back.png"];
    [backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didTapBackBarItem:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0.0f, 0.0f, backButtonImage.size.width, backButtonImage.size.height);
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    //Set add contact bar item for UINavigation Controller
    UIButton *addContactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *addContactImage = [UIImage imageNamed:@"icon_add_contact.png"];
    [addContactButton setBackgroundImage:addContactImage forState:UIControlStateNormal];
    [addContactButton addTarget:self action:@selector(didTapAddContactBarItem:) forControlEvents:UIControlEventTouchUpInside];
    addContactButton.frame = CGRectMake(0.0f, 0.0f, addContactImage.size.width, addContactImage.size.height);
    UIBarButtonItem *addContactButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addContactButton];
    self.navigationItem.rightBarButtonItem = addContactButtonItem;
}

- (void)didTapBackBarItem:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didTapAddContactBarItem:(id)sender {
    //Ask user for add contact into address book
//    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
//    ABRecordRef aRecord = ABPersonCreate();
//    CFErrorRef  anError = NULL;
//    
//    ABRecordSetValue(aRecord, kABPersonFirstNamePhoneticProperty, CFBridgingRetain(self.employee.name), &anError);
//    ABRecordSetValue(aRecord, kABPersonOrganizationProperty, @"2359Media", &anError);
//    
//    
//    //(@"adding email");
//    if(self.employee.userName){
//        ABMutableMultiValueRef emails = ABMultiValueCreateMutable(kABMultiStringPropertyType);
//        ABMultiValueAddValueAndLabel(emails, CFBridgingRetain(self.employee.userName), kABWorkLabel, NULL);
//        ABRecordSetValue(aRecord, kABPersonEmailProperty, emails, &anError);
//    }
//    
//    //(@"adding phonee");
//    ABMutableMultiValueRef phones = ABMultiValueCreateMutable(kABMultiStringPropertyType);
//    if(self.employee.contact) ABMultiValueAddValueAndLabel(phones, CFBridgingRetain(self.employee.contact), kABWorkLabel, NULL) ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationController delegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isMemberOfClass:[MEStaffDetailViewController class]]) {
        [self.tableView beginUpdates];
        NSArray *indexPathArray = [NSArray arrayWithObjects:
                                   [NSIndexPath indexPathForRow:0 inSection:0],
                                   [NSIndexPath indexPathForRow:1 inSection:0],
                                   [NSIndexPath indexPathForRow:2 inSection:0],
                                   [NSIndexPath indexPathForRow:3 inSection:0],
                                   [NSIndexPath indexPathForRow:4 inSection:0], nil];
        [self.tableView insertRowsAtIndexPaths:indexPathArray
                              withRowAnimation:UITableViewRowAnimationLeft];
        self.numOfRows = indexPathArray.count;
        [self.tableView endUpdates];

    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.cellHeightArray objectAtIndex:indexPath.row] doubleValue]	;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.numOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MELeftImageRightDetailCell *cell;
    switch (indexPath.row) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"AvatarAndRoleCell"];
            cell.rightDetail.text = self.employee.role;
            if (self.loadedAvatar) {
                cell.leftImage.image = self.loadedAvatar;
            }
            break;
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"EmailCell"];
            cell.rightDetail.text = self.employee.userName;
            break;
        }
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
            cell.rightDetail.text = self.employee.contact;
            break;
        }
        case 3: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LikeCell"];
            cell.rightDetail.text = self.employee.like;
            break;
        }
        case 4: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"DislikeCell"];
            cell.rightDetail.text = self.employee.dislike;
            break;
        }
        default:
            break;
    }
    
    cell.rightDetail.numberOfLines = 0;
    [cell.rightDetail sizeToFit];
    // Configure the cell...

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
