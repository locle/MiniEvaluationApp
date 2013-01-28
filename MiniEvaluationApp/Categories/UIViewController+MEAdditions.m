//
//  UIView+MEAdditions.m
//  MiniEvaluationApp
//
//  Created by loc on 1/28/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "UIViewController+MEAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIViewController (MEAdditions)

- (void)presentWithMEAnimationViewController:(UIViewController *)vc {
    [self presentViewController:vc animated:NO completion:^{
        vc.view.alpha = 0.0;
        vc.view.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.0, 1.0, 0);
        [UIView animateWithDuration:1.0f
                         animations:^{
                             vc.view.alpha = 1.0;
                             vc.view.layer.transform = CATransform3DMakeRotation(0, 0.0, 1.0, 0);
                         }
                         completion:^(BOOL finished) {
                         }];
    }];

}

@end
