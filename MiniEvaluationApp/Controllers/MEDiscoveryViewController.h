//
//  MEDiscoveryViewController.h
//  MiniEvaluationApp
//
//  Created by viet on 1/29/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SEMasonryView/SEMasonryView.h>

@interface MEDiscoveryViewController : UIViewController <SEMasonryViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonLoginLogout;
@property (weak, nonatomic) IBOutlet UILabel *textNoteOrLink;

@end
