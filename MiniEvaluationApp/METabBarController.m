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
//    self.tabBar.tintColor = [UIColor colorWithRed:235.0/255.0 green:119.0/255.0 blue:63.0/255.0 alpha:1.0];
//    UIImageView *companyLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"middle_button.png"]];
//    [self.view addSubview:companyLogo];
    
    
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
    self.selectedIndex = index;
    [self.delegate tabBarController:self didSelectViewController:[self.viewControllers objectAtIndex:index]];
}
@end
