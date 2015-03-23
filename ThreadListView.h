//
//  ThreadListView.h
//  threader
//
//  Created by Michael Krumdick on 3/12/15.
//  Copyright (c) 2015 mkrum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ThreadListView : UITableViewController
@property (retain) NSMutableArray *threads;
@property (strong, nonatomic) PFQuery *query;
@property (strong, nonatomic) CLLocation* location;
@property (strong, nonatomic) CLLocationManager* locationManager;

@end
