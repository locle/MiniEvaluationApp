//
//  VerticalCell.m
//  MasonryViewDemo
//
//  Created by Sarp Erdag on 3/30/12.
//  Copyright (c) 2012 Apperto. All rights reserved.
//

#import "VerticalCell.h"

@implementation VerticalCell

- (void) updateCellInfo:(NSDictionary *)data {
    
    self.text = [NSString stringWithFormat:@"%@ %@ %@", [data objectForKey:@"title"], [data objectForKey:@"title"], [data objectForKey:@"title"]];
    self.imageURL = [NSString stringWithFormat:@"http://farm%d.staticflickr.com/%@/%@_%@_q.jpg", [[data valueForKey:@"farm"] intValue], [data objectForKey:@"server"], [data objectForKey:@"id"], [data objectForKey:@"secret"]];
    
    [super updateCellInfo:data];
}

@end
