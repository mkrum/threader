//
//  MoreInfoViewController.m
//  threader
//
//  Created by Michael Krumdick on 3/19/15.
//  Copyright (c) 2015 mkrum. All rights reserved.
//

#import "MoreInfoViewController.h"

@interface UIViewController ()



@end

@implementation MoreInfoViewController

-(void) viewDidLoad{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self performSegueWithIdentifier:@"returnMain" sender:self];
    PFObject *area = [PFObject objectWithClassName:@"area"];
    [area setObject:_coordinates forKey:@"coordinates"];
    [area setObject: self.name.text forKey:@"Name"];
    NSMutableArray *zone = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D centerCoord;
    centerCoord.latitude = (CLLocationDegrees)(([_coordinates[0] doubleValue] + [_coordinates[2] doubleValue] + [_coordinates[4] doubleValue] + [_coordinates[6] doubleValue])/4);
    centerCoord.longitude =(CLLocationDegrees)(([_coordinates[1] doubleValue] + [_coordinates[3] doubleValue] + [_coordinates[5] doubleValue] + [_coordinates[7] doubleValue])/4);
    CLLocation *center = [[CLLocation alloc] initWithLatitude:centerCoord.latitude longitude:centerCoord.longitude];
    double radius = 0;
    CLLocationDistance distance = 0;
    for (int i = 0; i < 6; i = i + 2){
        CLLocationCoordinate2D temp;
        temp.latitude = [_coordinates[i] doubleValue];
        temp.longitude = [_coordinates[i+1] doubleValue];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:temp.latitude longitude:temp.longitude];
        distance = [loc distanceFromLocation:center];
        if (distance > radius)
            radius = distance;
    }
    [zone addObject:[NSNumber numberWithDouble:centerCoord.latitude]];
    [zone addObject:[NSNumber numberWithDouble:centerCoord.longitude]];
    [zone addObject:[NSNumber numberWithDouble:radius]];
    [area saveInBackground];
    [self.name resignFirstResponder];
    return YES;
}

@end


