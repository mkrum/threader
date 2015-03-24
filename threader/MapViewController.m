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
#import "MoreInfoViewController.h"


@interface ViewController ()

@end

@implementation MapViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager =[[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.location = [[CLLocation alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
        [self.locationManager startUpdatingLocation];
        self.location = self.locationManager.location;
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.location.coordinate.latitude
                                                                longitude:self.location.coordinate.longitude
                                                                     zoom:15];
        _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        _mapView.delegate = self;
        self.view = _mapView;
        _coordinates = [[NSMutableArray alloc]init];
        self.tapCount = 0;
        _path = [GMSMutablePath path];
        UIButton *clear = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [clear setFrame:CGRectMake(290, 590, 50,50 )];
        [clear setTitle:@"Reset" forState:UIControlStateNormal];
        [clear addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [clear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [clear setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:clear];
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
    _line = [GMSPolyline polylineWithPath:_path];
    _line.map = mapView;
    if (self.tapCount == 4){
        // Create a rectangular path
        GMSMutablePath *rect = [GMSMutablePath path];
        [rect addCoordinate:CLLocationCoordinate2DMake([_coordinates[0] doubleValue], [_coordinates[1] doubleValue])];
        [rect addCoordinate:CLLocationCoordinate2DMake([_coordinates[2] doubleValue], [_coordinates[3] doubleValue])];
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
        [self performSegueWithIdentifier:@"moreInfo" sender:self];
    }
    if (buttonIndex == 1){
        [self set];
    }
}
-(void) set{
    _tapCount = 0;
    _coordinates = [[NSMutableArray alloc] init];
    _path = [GMSMutablePath path];
    _coordinates = [[NSMutableArray alloc]init];
    [_mapView clear];
    
}

-(void)buttonPressed: (UIButton *) button {
    [self set];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"moreInfo"]) {
        MoreInfoViewController* moreInfo = (MoreInfoViewController *)segue.destinationViewController;
        moreInfo.coordinates = _coordinates;
    }
}


@end
