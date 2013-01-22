//
//  MEStaffAPIClient.m
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEStaffAPIClient.h"

@implementation MEStaffAPIClient

+ (id)sharedInstance
{
    static MEStaffAPIClient *__sharedInstance;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        __sharedInstance = [[MEStaffAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kStaffAPIBaseURL]];
    }   );
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        //custom settings [self setDefaultHeader:] or [self registerHTTPOperationClass:]
    }
    return self;
}

- (void)loadEmployeeListWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getPath:@"/api/1/databases/2359media/collections/user?apiKey=50bc7070e4b07d292a90b92b"
       parameters:nil
          success:success
          failure:failure];
}

@end
