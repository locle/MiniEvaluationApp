//
//  MELeftImageRightDetailCell.m
//  MiniEvaluationApp
//
//  Created by viet on 1/23/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEEmployeeDetailCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MEEmployeeDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpForEmployee:(MEEmployee *)employee
        withLoadedAvatar:(UIImage *)loadedAvatar
               andTarget:(id)target
             atIndexPath:(NSIndexPath *)indexPath; {
    
    [self.leftImage setFrame:CGRectMake(40, 11, 22, 22)];
    
    switch (indexPath.row) {
        case 0: {
            [self.leftImage setFrame:CGRectMake(10, 5, 60, 60)];
            self.rightDetail.text = employee.role;
            if (loadedAvatar) {
                self.leftImage.image = loadedAvatar;
                self.leftImage.layer.cornerRadius = self.leftImage.frame.size.width / 2;
                self.leftImage.clipsToBounds = YES;
            } else {
                self.leftImage.image = [UIImage imageNamed:@"icon_profile.png"];
            }
            break;
        }
        case 1: {
            self.leftImage.image = [UIImage imageNamed:@"icon_email.png"];
            if (employee.userName) {
                self.rightDetail.text = employee.userName;
                UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTapEmail)];
                [self.rightDetail addGestureRecognizer:tapGestureRecognizer];
            }
            break;
        }
        case 2: {
            self.leftImage.image = [UIImage imageNamed:@"icon_sms.png"];
            if (employee.contact) {
                self.rightDetail.text = employee.contact;
                UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTapContactNumber)];
                [self.rightDetail addGestureRecognizer:tapGestureRecognizer];
            }
            break;
        }
        case 3: {
            self.leftImage.image = [UIImage imageNamed:@"icon_like.png"];
            self.rightDetail.text = employee.like;
            break;
        }
        case 4: {
            self.leftImage.image = [UIImage imageNamed:@"icon_dislike.png"];
            self.rightDetail.text = employee.dislike;
            break;
        }
        default:
            break;
    }
    
    self.rightDetail.numberOfLines = 0;
    [self.rightDetail sizeToFit];

}

@end
