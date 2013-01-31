//
//  MEPhotoAnnotation.h
//  MiniEvaluationApp
//
//  Created by viet on 1/31/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MEPhotoAnnotation : NSObject <MKAnnotation>

+ (MEPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo;
+ (MEPhotoAnnotation *)annotationForTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate;


@property (nonatomic, strong) NSDictionary *photo;

@end

