//
//  METabBarViewController.h
//  MiniEvaluationApp
//
//  Created by viet on 1/22/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "METabBarView.h"

@interface METabBarController : UITabBarController <METabBarDelegate>

@property (nonatomic, retain) IBOutlet METabBarView *customTabBarView;

@end
