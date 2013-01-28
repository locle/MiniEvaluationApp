//
//  MEStaffDetailViewController.h
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>


@interface MEStaffDetailViewController : UIViewController <UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@property (nonatomic, strong) MEEmployee *employee;
@property (nonatomic, strong) UIImage *loadedAvatar;

@end
