//
//  MapViewController.m
//  threader
//
//  Created by Michael Krumdick on 3/10/15.
//  Copyright (c) 2015 mkrum. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "GoogleMaps.h"


@interface ViewController ()

@end

@implementation MapViewController
- (void)viewDidLoad {
        [super viewDidLoad];
        self.locationManager =[[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.location = [[CLLocation alloc] init];
        [self.locationManager requestWhenInUseAuthorization];
        if ([CLLocationManager instancesRespondToSelector:@selector(requestWhenInUseAuthorization)]){
        [self.locationManager startUpdatingLocation];
        self.location = self.locationManager.location;
        NSLog(@"%f", self.location.coordinate.latitude);
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.location.coordinate.latitude
                                                                longitude:self.location.coordinate.longitude
                                                                     zoom:15];
        _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        _mapView.delegate = self;
        self.view = _mapView;
        _coordinates = [[NSMutableArray alloc]init];
        self.tapCount = 0;
        _path = [GMSMutablePath path];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// delegate methods
-(void) mapView: (GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    self.tapCount = self.tapCount + 1;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = mapView;
    double longitude = coordinate.longitude;
    double latitude = coordinate.latitude;
    [_coordinates addObject:[NSNumber numberWithDouble: latitude]];
    [_coordinates addObject:[NSNumber numberWithDouble: longitude]];
    [_path addCoordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)];
    GMSPolyline *line = [GMSPolyline polylineWithPath:_path];
    line.map = mapView;
    if (self.tapCount == 4){
        // Create a rectangular path
        GMSMutablePath *rect = [GMSMutablePath path];
        [rect addCoordinate:CLLocationCoordinate2DMake([_coordinates[0] doubleValue], [_coordinates[1] doubleValue])];
        _point1 = [PFGeoPoint geoPointWithLatitude:[_coordinates[0] doubleValue] longitude:[_coordinates[1] doubleValue]];
        [rect addCoordinate:CLLocationCoordinate2DMake([_coordinates[2] doubleValue], [_coordinates[3] doubleValue])];
        _point2 = [PFGeoPoint geoPointWithLatitude:[_coordinates[2] doubleValue] longitude:[_coordinates[3] doubleValue]];
        [rect addCoordinate:CLLocationCoordinate2DMake([_coordinates[4] doubleValue], [_coordinates[5] doubleValue])];
        [rect addCoordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)];
        
        // Create the polygon, and assign it to the map.
        GMSPolygon *polygon = [GMSPolygon polygonWithPath:rect];
        polygon.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.05];
        polygon.strokeColor = [UIColor blackColor];
        polygon.strokeWidth = 2;
        polygon.map = mapView;
        [NSTimer scheduledTimerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(alert:)
                                       userInfo:nil
                                        repeats:NO];
    }
}
-(void)alert: (NSTimer *) timer{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Is this the area you want?"
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:nil];
    [alert addButtonWithTitle:@"No"];
    [alert show];
}
-(void)alertView: (UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        PFObject *area = [PFObject objectWithClassName:@"area"];
        [area setObject:_coordinates forKey:@"coordinates"];
        [area saveInBackground];
        [_mapView clear];
    }
    if (buttonIndex == 1){
        [_mapView clear];
    }
}


@end
