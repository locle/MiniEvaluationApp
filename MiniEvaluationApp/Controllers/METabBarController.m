//
//  METabBarViewController.m
//  MiniEvaluationApp
//
//  Created by viet on 1/22/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "METabBarController.h"

@implementation METabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hideExistingTabBar];
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"METabBarView" owner:self options:nil];
    self.customTabBarView = [nibObjects objectAtIndex:0];
    
    self.customTabBarView.delegate = self;
    
    CGRect bottomLocation = self.customTabBarView.frame;
    bottomLocation.origin.y = self.view.frame.size.height - self.customTabBarView.frame.size.height;
    [self.customTabBarView setFrame:bottomLocation];
    self.customTabBarView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.customTabBarView];
}

- (void)hideExistingTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}


- (void)tabWasSelected:(NSInteger)index {
    UIViewController *selectedVC = [self.viewControllers objectAtIndex:index];
    selectedVC.view.alpha = 0.0;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         selectedVC.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                     }];
    self.selectedIndex = index;
}
@end
