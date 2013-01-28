//
//  MEStaffAPIClient.h
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface MEStaffAPIClient : AFHTTPClient

+ (id)sharedInstance;

- (void)loadEmployeeListWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
