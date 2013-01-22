//
//  METabBarView.m
//  MiniEvaluationApp
//
//  Created by viet on 1/22/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "METabBarView.h"

@implementation METabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (IBAction) touchButton:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(tabWasSelected:)]) {
        if (self.currentButton) {
            if (self.currentButton.tag == 0) {
                [self.currentButton setImage:[UIImage imageNamed:@"icon_contacts.png"] forState:UIControlStateNormal];
            } else {
                [self.currentButton setImage:[UIImage imageNamed:@"icon_info.png"] forState:UIControlStateNormal];
            }
        }
        
        self.currentButton = sender;
        
        if (self.currentButton.tag == 0) {
            [self.currentButton setImage:[UIImage imageNamed:@"icon_contacts_selected.png"] forState:UIControlStateNormal];
            [self performAnimation:self.currentButton];
        } else {
            [self.currentButton setImage:[UIImage imageNamed:@"icon_info_selected.png"] forState:UIControlStateNormal];
            [self performAnimation:self.currentButton];
        }
        
        [self.delegate tabWasSelected:self.currentButton.tag];
    }
}

- (void)performAnimation:(UIView *)view {
    [UIView beginAnimations:@"View Fade In" context:nil];
    [UIView setAnimationDuration:1.0];
    view.alpha = 0.0;
    view.alpha = 1.0;
    [UIView commitAnimations];
}

@end
