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
#import <QuartzCore/QuartzCore.h>

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
    NSString *message = [NSString stringWithFormat:@"Do you want to add %@ to your Address Book?", self.employee.name];
    UIAlertView *addContactAlert = [[UIAlertView alloc] initWithTitle:message
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Ok", nil];
    [addContactAlert setAlertViewStyle:UIAlertViewStyleDefault];
    [addContactAlert show];
    DLog(@"test");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        CFErrorRef  anError = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &anError);
        ABRecordRef newContact = ABPersonCreate();

        //Contact properties which are only constant strings
        ABRecordSetValue(newContact, kABPersonFirstNameProperty, CFBridgingRetain(self.employee.name), &anError);
        ABRecordSetValue(newContact, kABPersonOrganizationProperty, @"2359Media", &anError);
        ABRecordSetValue(newContact, kABPersonNoteProperty, CFBridgingRetain(self.employee.role), &anError);
        //Contact properties which are ABMutableMultiValueRef
        //Phone
        if(self.employee.contact) {
            ABMutableMultiValueRef phones = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            ABMultiValueAddValueAndLabel(phones, CFBridgingRetain(self.employee.contact), kABWorkLabel, NULL) ;
            ABRecordSetValue(newContact, kABPersonPhoneProperty, phones, &anError);
        }
        //Email
        if(self.employee.userName){
            ABMutableMultiValueRef emails = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            ABMultiValueAddValueAndLabel(emails, CFBridgingRetain(self.employee.userName), kABWorkLabel, NULL);
            ABRecordSetValue(newContact, kABPersonEmailProperty, emails, &anError);
        }

        ABAddressBookAddRecord(addressBook, newContact, &anError);
        ABAddressBookSave(addressBook, &anError);
        if (anError != NULL)
        {
            UIAlertView *addContactAlert = [[UIAlertView alloc] initWithTitle:@"Contact has not been added into Address Book!"
                                                                      message:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
            [addContactAlert setAlertViewStyle:UIAlertViewStyleDefault];
            [addContactAlert show];
        }
    }
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
                cell.leftImage.layer.cornerRadius = cell.leftImage.frame.size.width / 2;
                cell.leftImage.clipsToBounds = YES;
            }
            break;
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"EmailCell"];
            if (self.employee.userName) {
                cell.rightDetail.text = self.employee.userName;
                UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTapEmail)];
                [cell.rightDetail addGestureRecognizer:tapGestureRecognizer];
            }
            break;
        }
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
            if (self.employee.contact) {
                cell.rightDetail.text = self.employee.contact;
                UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTapContactNumber)];
                [cell.rightDetail addGestureRecognizer:tapGestureRecognizer];
            }
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
    return cell;
}

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

#pragma mark - Tap gesture recognizer handle
- (void)userDidTapEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        if (mailVC) {
            mailVC.mailComposeDelegate = self;
            [mailVC setToRecipients:[NSArray arrayWithObject:self.employee.userName]];
            
            [self presentWithMEAnimationViewController:mailVC];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidTapContactNumber {
    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
    if (messageVC) {
        messageVC.messageComposeDelegate = self;
        [messageVC setRecipients:[NSArray arrayWithObject:self.employee.contact]];
        [self presentViewController:messageVC animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
