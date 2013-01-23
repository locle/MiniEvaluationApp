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
