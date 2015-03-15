//
//  MapViewController.h
//  threader
//
//  Created by Michael Krumdick on 3/10/15.
//  Copyright (c) 2015 mkrum. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController<GMSMapViewDelegate>

@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) GMSMutablePath *path;
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) PFGeoPoint *point1;
@property (strong, nonatomic) PFGeoPoint *point2;
@property NSMutableArray *coordinates;
@property int tapCount;
@end
