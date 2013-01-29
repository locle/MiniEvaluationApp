//
//  MEModel.h
//  MiniEvaluationApp
//
//  Created by viet on 1/29/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEModel : NSObject <NSCoding>

- (NSString *)description;

- (id)initWithDictionary:(NSDictionary*)dict;
- (id)updateWithDictionary:(NSDictionary*)dict;
- (id)updateWithModel:(MEModel *)newModel;
- (id)createCopy;

- (NSDictionary*)toDictionary;
- (NSDictionary*)toDictionaryUseNullValue:(BOOL)useNull;


@end
