//
//  UIFont+MEAdditions.m
//  MiniEvaluationApp
//
//  Created by loc on 1/27/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "UIFont+MEAdditions.h"

@implementation UIFont (MEAdditions)

+ (UIFont *)meFontOfSize:(CGFloat)fontSize {
    UIFont *theFont = [UIFont fontWithName:@"MyriadPro-Regular" size:fontSize];
    
    if (theFont == nil)
        theFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:fontSize];
    return theFont;
}

@end
