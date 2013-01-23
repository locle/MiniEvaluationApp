//
//  MEStaffDetailViewController.h
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEEmployee.h"

@interface MEStaffDetailViewController : UITableViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) MEEmployee *employee;
@property (nonatomic, strong) UIImage *loadedAvatar;


@end
