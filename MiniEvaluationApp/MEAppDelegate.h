//
//  MEAppDelegate.h
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UITabBarController *tabBarController;

@property (strong, nonatomic) FBSession *session;


extern NSString *const FBSessionStateChangedNotification;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

@end

