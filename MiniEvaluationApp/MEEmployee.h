//
//  MEEmployee.h
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEEmployee : NSObject <NSCoding>

@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) NSDate *timeStamp;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *like;
@property (nonatomic, strong) NSString *dislike;

@property (nonatomic, strong) NSNumber *visitCount;

+ (NSDictionary *)employeeListFromDataArray:(NSArray *)dataArray;

@end
