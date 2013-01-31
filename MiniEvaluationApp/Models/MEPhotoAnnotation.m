//
//  MEPhotoAnnotation.m
//  MiniEvaluationApp
//
//  Created by viet on 1/31/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEPhotoAnnotation.h"

#define FLICKR_PHOTO_TITLE @"title"
#define FLICKR_PHOTO_DESCRIPTION @"description._content"
#define FLICKR_PLACE_NAME @"_content"
#define FLICKR_PHOTO_ID @"id"
#define FLICKR_PHOTO_OWNER @"ownername"
#define FLICKR_LATITUDE @"latitude"
#define FLICKR_LONGITUDE @"longitude"

@interface MEPhotoAnnotation()
@property (nonatomic, copy) NSString *myTitle;
@property (nonatomic, copy) NSString *mySubtitle;
@property (nonatomic, assign) CLLocationCoordinate2D myCoordinate;
@end

@implementation MEPhotoAnnotation

+ (MEPhotoAnnotation *)annotationForPhoto:(NSDictionary *)photo
{
    MEPhotoAnnotation *annotation = [[MEPhotoAnnotation alloc] init];
    annotation.photo = photo;
    return annotation;
}


+ (MEPhotoAnnotation *)annotationForTitle:(NSString *)title
                                 subtitle:(NSString *)subtitle
                               coordinate:(CLLocationCoordinate2D)coordinate {
    MEPhotoAnnotation *annotation = [[MEPhotoAnnotation alloc] init];
    annotation.myTitle = title;
    annotation.mySubtitle = subtitle;
    annotation.myCoordinate = coordinate;
    return annotation;
}
#pragma mark - MKAnnotation

- (NSString *)title
{
    return self.myTitle;
}

- (NSString *)subtitle
{
    return self.mySubtitle;
}


- (CLLocationCoordinate2D)coordinate
{
    return self.myCoordinate;
}
@end
