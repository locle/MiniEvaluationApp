//
//  MEDiscoveryViewController.m
//  MiniEvaluationApp
//
//  Created by viet on 1/29/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEDiscoveryViewController.h"
#import "MEAppDelegate.h"
#import "VerticalCell.h"
#import "HorizontalCell.h"

@interface MEDiscoveryViewController ()
@property (strong, nonatomic) SEMasonryView *masonryView;
@property (nonatomic, strong) NSMutableArray *photos;
@property (readwrite,assign) int screenWidth;
@end

@implementation MEDiscoveryViewController
- (void)awakeFromNib {
    [SEMasonryView class];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self updateView];
//    MEAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!FBSession.activeSession.isOpen) {
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            [self openSessionWithAllowLoginUI:YES];
        }
    }
    
    // create and add masonryView
    self.screenWidth = self.view.frame.size.width;
    self.masonryView = [[SEMasonryView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50)];
    
    // set delegate to self
    self.masonryView.delegate = self;
    // if iPhone, set it to 160px
    self.masonryView.columnWidth = 160;
//    self.masonryView.rowHeight = 130; //Set when in horizontal mode
    // enable paging
    self.masonryView.loadMoreEnabled = YES;
    
//    // optional
    self.masonryView.backgroundColor = [UIColor darkGrayColor];
//
//    // optional
    self.masonryView.horizontalModeEnabled = NO;
    
    // add it to your default view
    [self.view addSubview:self.masonryView];

    
    [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FaceBookSession
- (IBAction)authButtonPressed:(id)sender {    
//    MEAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    if (FBSession.activeSession.isOpen) {
        [FBSession.activeSession closeAndClearTokenInformation];
        
    } else {
        if (FBSession.activeSession.state != FBSessionStateCreatedTokenLoaded) {
            // Create a new, logged out session.
            [self openSessionWithAllowLoginUI:YES];
        }
    }
    
    [self updateView];
}

- (void)updateView {
    // get the app delegate, so that we can reference the session property
    if (FBSession.activeSession.isOpen) {
        // valid account UI is shown whenever the session is open
        [self.buttonLoginLogout setTitle:@"Log out" forState:UIControlStateNormal];
        [self.textNoteOrLink setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
                                      FBSession.activeSession.accessToken]];
        self.textNoteOrLink.numberOfLines = 0;
    } else {
        // login-needed account UI is shown whenever the session is closed
        [self.buttonLoginLogout setTitle:@"Log in" forState:UIControlStateNormal];
        [self.textNoteOrLink setText:@"Login to create a link to fetch account data"];
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                DLog(@"User session found");
                [self updateView];
            } else {
//                DLog(@"%@", error.debugDescription);
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [self updateView];
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionStateChangedNotification object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_status",
                            @"friends_status",
                            nil];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
    
//    NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_checkins", nil];
//    return [FBSession openActiveSessionWithPublishPermissions:permissions
//                                              defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:NO completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//                                                  [self sessionStateChanged:session
//                                                                      state:status
//                                                                      error:error];
//                                              }];
    
//    FBSession *session = [[FBSession alloc] initWithAppID:nil permissions:permissions urlSchemeSuffix:nil tokenCacheStrategy:nil];
//    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView
//            completionHandler:^(FBSession *session,
//                                FBSessionState status,
//                                NSError *error) {
//                // this handler is called back whether the login succeeds or fails; in the
//                // success case it will also be called back upon each state transition between
//                // session-open and session-close
//                [self sessionStateChanged:session
//                                    state:status
//                                    error:error];
//            }];

}

#pragma mark - PinterestView
int pageCounter = 1;
- (void) fetchData {
    // [MyClass _keepAtLinkTime]; Just call a method it inherits from NSObject once
    [SEMasonryView class];
    // set your MasonryView to be in loading state
    self.masonryView.loading = YES;
    
    // disable the reload button
//    reloadButton.enabled = NO;
    
    // load data from Flickr's API. In this case, a search with the keyword "Lego" is made and 10 results are returned in each page.
    // The call uses AFNetworking Library, can be grabbed for free from https://github.com/AFNetworking/AFNetworking
    // Of course, you can use any networking library or Apple's default libraries for this task
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=5dcaac7a6155238356c4d94244c98f2d&text=fall+creek+falls&per_page=20&page=%d&format=json&nojsoncallback=1", pageCounter];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        DLog(@"%@", [JSON class]);
    
        for (NSDictionary *photo in [[JSON valueForKey:@"photos"] valueForKey:@"photo"]) {
            
            // add each of the photo object to your array, so that you can reference them on other methods
            [self.photos addObject:photo];
            
            // create a cell for each photo and add it to your MasonryView
            SEMasonryCell *cell;
            
            if (self.masonryView.horizontalModeEnabled){
                cell = [[[NSBundle mainBundle] loadNibNamed:@"HorizontalCell" owner:self options:nil] objectAtIndex: 0];
            }
            else {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"VerticalCell" owner:self options:nil] objectAtIndex: 0];
            }
            cell.horizontalModeEnabled = self.masonryView.horizontalModeEnabled;
            
            // set a tag for your cell, so that you can refer to it when there are interactions like tapping etc..
            cell.tag = [self.photos indexOfObject:photo];
            
            // set the cell's size, if you want to play with cell spacings and stuff, this is the place
            if (self.screenWidth % 256 == 0) { // for ipad
                if (self.masonryView.horizontalModeEnabled)
                    [cell setFrame:CGRectMake(10, 10, cell.frame.size.width + 15, 216)];
                else
                    [cell setFrame:CGRectMake(10, 10, 236, cell.frame.size.height + 15)];
            }
            else { // for iphone
                [cell setFrame:CGRectMake(15, 15, 140, cell.frame.size.height + 200)];
            }
            
            // finally, update the cell's controls with the data coming from the API
            [cell updateCellInfo:photo];
            
            // add it to your MasonryView
            [self.masonryView addCell:cell];
            
            // enable the reload button
            
        }
        // you are done loading, so turn off MasonryView's loading state
        self.masonryView.loading = NO;
//        reloadButton.enabled = YES;
    }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {                DLog(@"error");
                                                                                                // if there has been an error, again turn of MasonryView's loading state
                                                                                            self.masonryView.loading = NO;
//                                                                                           reloadButton.enabled = YES;
                                                                                            }];
                                                                                        
    [operation start];
    
    // increase the counter so that the next time this method loads, it is gonna load the next page
    pageCounter++;
}

- (void) didEnterLoadingMode {
    
    // fetch data again if it is dragged and released in the bottom
    [self fetchData];
}

- (void) didSelectItemAtIndex:(int) index {
    
    // define some actions when a cell is tapped.
    // in this case an alert with the cell's title is shown
    
    NSDictionary *photo = [self.photos objectAtIndex:index];
    
    NSString *message = [NSString stringWithFormat:@"%@", [photo objectForKey:@"title"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tapped!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
