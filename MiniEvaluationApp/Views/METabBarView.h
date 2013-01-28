//
//  METabBarView.h
//  MiniEvaluationApp
//
//  Created by viet on 1/22/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>

//Delegate methods for responding to TabBar events
@protocol METabBarDelegate <NSObject>

//Handle tab bar touch events, sending the index of the selected tab
- (void)tabWasSelected:(NSInteger)index;

@end



@interface METabBarView : UIView

@property (nonatomic, assign) NSObject<METabBarDelegate> *delegate;

@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *contactButton;

- (IBAction)touchInfoButton;
- (IBAction)touchContactButton;

@end
