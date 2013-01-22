//
//  MEExtendStaffAPIClient.m
//  MiniEvaluationApp
//
//  Created by viet on 1/21/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEExtendStaffAPIClient.h"

@implementation MEExtendStaffAPIClient

+ (id)sharedInstance
{
    static MEExtendStaffAPIClient *__sharedInstance;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        __sharedInstance = [[MEExtendStaffAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kExtendStaffAPIBaseURL]];
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


@end
