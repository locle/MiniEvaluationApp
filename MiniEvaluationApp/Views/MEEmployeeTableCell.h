//
//  MEEmployeeListCell.h
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEEmployeeTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIImageView *highestVisitedMark;

- (void)setUpWithEmployee:(MEEmployee *)employee isHighestVisitedEmployee:(BOOL)isHighestVisitedEmployee andTarget:(id)target;


@end
