//
//  MEAppDelegate.m
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEAppDelegate.h"

@implementation MEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.tabBarController = (UITabBarController *)self.window.rootViewController;
    self.tabBarController.delegate = self;

    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:235.0/255.0 green:119.0/255.0 blue:63.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIFont fontWithName:@"Helvetica Neue Bold" size:20.0], UITextAttributeFont, nil]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - TabBar delegate - customize tab view transition
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [UIView beginAnimations:@"View Fade In" context:nil];
    [UIView setAnimationDuration:1.0];
    
    //    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
    //                           forView:self.tabBarController.view cache:YES];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.tabBarController.selectedViewController.view.alpha = 0.0;
    self.tabBarController.selectedViewController.view.alpha = 1.0;
    [UIView commitAnimations];
    
//    [UIView animateWithDuration:1.0
//                          delay:0
//                        options:UIViewAnimationOptionBeginFromCurrentState
//                     animations:^{
//                         [token setFrame:CGRectMake(xx, 0, 64, 64)];
//                         //here you may add any othe actions, but notice, that ALL of them will do in SINGLE step. so, we setting ONLY xx coordinate to move it horizantly first.
//                     }
//                     completion:^(BOOL finished){
//                         
//                         //here any actions, thet must be done AFTER 1st animation is finished. If you whant to loop animations, call your function here.
//                         [UIView animateWithDuration:0.5
//                                               delay:0
//                                             options:UIViewAnimationOptionBeginFromCurrentState
//                                          animations:^{[token setFrame:CGRectMake(xx, yy, 64, 64)];} // adding yy coordinate to move it verticaly}
//                                          completion:nil];
//                     }];
}

@end

