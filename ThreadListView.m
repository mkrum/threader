//
//  ThreadListView.m
//  threader
//
//  Created by Michael Krumdick on 3/12/15.
//  Copyright (c) 2015 mkrum. All rights reserved.
//

#import "ThreadListView.h"
#import <GoogleMaps/GoogleMaps.h>
#import "postView.h"

@interface UIViewController ()

@end

@implementation ThreadListView

-(void) viewDidLoad{
    self.threads = [[NSMutableArray alloc]init];
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager startUpdatingLocation];
    self.location = self.locationManager.location;
    [self.threads addObject:@""];
    [self populateThreads];
}

-(void) populateThreads{
    self.query = [PFQuery queryWithClassName:@"area"];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        for (PFObject *object in objects) {
            
             CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(self.location.coordinate.latitude, self.location.coordinate.longitude);
            NSMutableArray *locationData = [[NSMutableArray alloc]init];
            [locationData addObjectsFromArray:[object objectForKey:@"coordinates"]];
            GMSMutablePath *path = [[GMSMutablePath alloc]init];
            for (int j = 0; j <=4; j = j + 2) {
                [path addCoordinate:CLLocationCoordinate2DMake((CLLocationDegrees)[locationData[j] doubleValue], (CLLocationDegrees)[locationData[j + 1] doubleValue])];
            }
            GMSCoordinateBounds *region = [[GMSCoordinateBounds alloc]initWithPath:path];
            if ([region containsCoordinate:loc]){
                [self.threads addObject:[object objectForKey:@"Name"]];
            }
            }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addView];
        });
    }];
}

-(void) addView{
    UITableView *myTableView    =   [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    myTableView.dataSource      =   self;
    myTableView.delegate        =   self;
    [self.view addSubview:myTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.threads count];
}

- (UITableViewCell *)tableView:(UITableView *)tmpTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier         =   @"MainCell";
    UITableViewCell *cell               =   [tmpTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell    =   [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.threads objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.index = indexPath.row;
    [self performSegueWithIdentifier:@"showPost" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showPost"]) {
        postView* moreInfo = (postView *)segue.destinationViewController;
        moreInfo.name = self.threads[self.index];
    }
}




@end
