//
//  MELeftImageRightDetailCell.h
//  MiniEvaluationApp
//
//  Created by viet on 1/23/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEEmployeeDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rightDetail;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;

- (void)setUpForEmployee:(MEEmployee *)employee
        withLoadedAvatar:(UIImage *)loadedAvatar
               andTarget:(id)target
             atIndexPath:(NSIndexPath *)indexPath;

@end
