//
//  MEEmployeeListCell.m
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEEmployeeTableCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MEEmployeeTableCell

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

- (void)setUpWithEmployee:(MEEmployee *)employee atIndexPath:(NSIndexPath *)indexPath isHighestVisitedEmployee:(BOOL)isHighestVisitedEmployee andTarget:(id)target {
    self.title.text = employee.name;
    if ([employee.gender isEqualToString:@"female"]) {
        self.title.textColor = [UIColor orange1];
    } else {
        self.title.textColor = [UIColor blue1];
    }
    
    //    for ( NSString *familyName in [UIFont familyNames] ) { NSLog(@"Family %@", familyName); NSLog(@"Names = %@", [UIFont fontNamesForFamilyName:familyName]); }
    self.subTitle.font = [UIFont meFontOfSize:10];
    self.subTitle.textColor = [UIColor gray1];
    self.subTitle.text = employee.role;
    [self.leftImage setImageWithURL:[NSURL URLWithString:employee.imageLink] placeholderImage:[UIImage imageNamed:@"icon_profile.png"]];
    self.leftImage.layer.cornerRadius = self.leftImage.frame.size.height / 2;
    self.leftImage.clipsToBounds = YES;
    
    
    if (isHighestVisitedEmployee) {
        self.highestVisitedMark.image = [UIImage imageNamed:@"icon_star.png"];
    } else {
        self.highestVisitedMark.image = nil;
    }
    self.contentView.backgroundColor = (indexPath.row % 2) ? [UIColor gray2] : [UIColor gray3];
}


@end
