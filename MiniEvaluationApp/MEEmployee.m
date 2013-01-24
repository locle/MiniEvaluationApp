//
//  MEEmployee.m
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEEmployee.h"


NSString* const kASCEmployeeUserName = @"userName";
NSString* const kASCVisitCount = @"visitCount";


@implementation MEEmployee

- (NSDate *)timeStamp {
    if (!_timeStamp) {
        _timeStamp = [[NSDate alloc] init];
    }
    return _timeStamp;
}


+ (MEEmployee *)highestVisitedEmployeeFromDataArray:(NSArray *)employeeList {
    MEEmployee *highestVisittedEmployee;
    if ([employeeList.lastObject isKindOfClass:[MEEmployee class]]) {
        highestVisittedEmployee = employeeList.lastObject;
    }
    
    for (id object in employeeList) {
        if ([object isKindOfClass:[MEEmployee class]]) {
            MEEmployee *employee = object;
            if ([employee.visitCount compare:highestVisittedEmployee.visitCount] == NSOrderedDescending) {
                highestVisittedEmployee = employee;
            }
        }
    }
    return highestVisittedEmployee;
}

+ (NSDictionary *)employeeListFromDataArray:(NSArray *)dataArray
{
    NSMutableDictionary *mutableEmployeeList = [[NSMutableDictionary alloc] init];
    for (NSDictionary *dict in dataArray) {
        MEEmployee *employee = [MEEmployee employeeFromDictionary:dict];
        [mutableEmployeeList setObject:employee forKey:employee.userName];
    }
    return [mutableEmployeeList copy];
    
}

+ (MEEmployee *)employeeFromDictionary:(NSDictionary *)dictionary {
    MEEmployee *employee = [[MEEmployee alloc] init];
    
    employee.userName = [dictionary objectForKey:@"userName"];
    employee.name = [dictionary objectForKey:@"name"];
    employee.role = [dictionary objectForKey:@"role"];
    employee.like = [dictionary objectForKey:@"like"];
    employee.dislike = [dictionary objectForKey:@"dislike"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"M/d/yy HH:mm";
    employee.timeStamp = [dateFormatter dateFromString:[dictionary objectForKey:@"timeStamp"]];
    employee.gender = [dictionary objectForKey:@"gender"];
    employee.imageLink = [dictionary objectForKey:@"image"];
    employee.contact = [dictionary objectForKey:@"contact"];
    employee.visitCount = 0;
    
    return employee;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    
    return [self.userName isEqual:((MEEmployee *)other).userName];
}


#pragma mark - NSCoding implementation
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userName forKey:kASCEmployeeUserName];
    [aCoder encodeObject:self.visitCount forKey:kASCVisitCount];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _userName = [aDecoder decodeObjectForKey:kASCEmployeeUserName];
        _visitCount = [aDecoder decodeObjectForKey:kASCVisitCount];
    }
    return self;
}
@end
