//
//  MEMapViewController.m
//  MiniEvaluationApp
//
//  Created by viet on 1/31/13.
//  Copyright (c) 2013 2359media. All rights reserved.
//

#import "MEMapViewController.h"
#import "MEPhotoAnnotation.h"

@interface MEMapViewController () <MKMapViewDelegate>

@end

@implementation MEMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //CLLocation: model
    //Sentosa island Singapore : latitude:1.247107, longtitude:103.832388
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(1.247107, 103.832388); //(double, double)
    
    CLLocationDistance locationDistance = 10;    //(double) a distance in meters.
    CLLocationAccuracy locationAccuracy = 10;   //(double) location accuracy level in meters.
    /*
    kCLLocationAccuracyBestForNavigation; // phone should be plugged in to power source
    kCLLocationAccuracyBest; 
    kCLLocationAccuracyNearestTenMeters;
    kCLLocationAccuracyHundredMeters;
    kCLLocationAccuracyKilometer;
    kCLLocationAccuracyThreeKilometers;
     The more accuracy you request, the more battery will be used Device “does its best” given a specified accuracy request
     Cellular tower triangulation (not very accurate, but low power)
     WiFi node database lookup (more accurate, more power)
     ￼GPS (very accurate, lots of power)
    */
    CLLocationDirection locationDirection = 0;  //(double) in degrees from 0 to 359.9. A negative value indicates an invalid direction.
    CLLocationSpeed locationSpeed = 10;         //(double) meters per second.
    NSDate *locationTimestamp = [NSDate dateWithTimeIntervalSinceNow:0];
    
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:locationCoordinate
                                                         altitude:locationDistance
                                               horizontalAccuracy:kCLLocationAccuracyBestForNavigation
                                                 verticalAccuracy:kCLLocationAccuracyBestForNavigation
                                                           course:locationDirection
                                                            speed:locationSpeed
                                                        timestamp:locationTimestamp];
    
    //MKAnnotation: protocol
    MEPhotoAnnotation *annotation = [MEPhotoAnnotation annotationForTitle:@"Sentosa Island" subtitle:@"subtitle" coordinate:locationCoordinate];

    self.mapView.delegate = self;
    [self.mapView addAnnotation:annotation];
    [self.mapView setCenterCoordinate:annotation.coordinate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        // could put a rightCalloutAccessoryView here
    }
    
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    UIImage *image = [UIImage imageNamed:@"spinner"];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
}

@end
