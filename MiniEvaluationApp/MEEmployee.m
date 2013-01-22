//
//  MEEmployee.m
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEEmployee.h"


NSString* const kASCEmployeeId = @"oid";
NSString* const kASCVisitCount = @"visitCount";


@implementation MEEmployee

- (NSDate *)timeStamp {
    if (!_timeStamp) {
        _timeStamp = [[NSDate alloc] init];
    }
    return _timeStamp;
}


+ (NSDictionary *)employeeListFromDataArray:(NSArray *)dataArray
{
    NSMutableDictionary *mutableEmployeeList = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dict in dataArray) {
        MEEmployee *employee = [MEEmployee employeeFromDictionary:dict];
        [mutableEmployeeList setObject:employee forKey:employee.oid];
    }
    return [mutableEmployeeList copy];
    
}

+ (MEEmployee *)employeeFromDictionary:(NSDictionary *)dictionary {
    MEEmployee *employee = [[MEEmployee alloc] init];
    
    employee.oid = [[dictionary objectForKey:@"_id"] objectForKey:@"$oid"];
    employee.userName = [dictionary objectForKey:@"userName"];
    employee.name = [dictionary objectForKey:@"name"];
    employee.role = [dictionary objectForKey:@"role"];
    employee.like = [dictionary objectForKey:@"like"];
    employee.dislike = [dictionary objectForKey:@"dislike"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"M/d/yy HH:mm";
    employee.timeStamp = [dateFormatter dateFromString:[dictionary objectForKey:@"timeStamp"]];
    
    employee.visitCount = 0;
    
    return employee;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    
    return [self.oid isEqual:((MEEmployee *)other).oid];
}


#pragma mark - NSCoding implementation
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.oid forKey:kASCEmployeeId];
    [aCoder encodeObject:self.visitCount forKey:kASCVisitCount];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _oid = [aDecoder decodeObjectForKey:kASCEmployeeId];
        _visitCount = [aDecoder decodeObjectForKey:kASCVisitCount];
    }
    return self;
}
@end
