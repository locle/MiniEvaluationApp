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
        __sharedInstance = [[MEStaffAPIClient alloc] initWithBaseURL:[NSURL URLWithString:MEAPP_API_HOST]];
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
    [self getPath:@"/u/11295402/MiniEval/data.json"
       parameters:nil
          success:success
          failure:failure];
}

@end
