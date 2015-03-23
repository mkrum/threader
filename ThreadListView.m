//
//  ThreadListView.m
//  threader
//
//  Created by Michael Krumdick on 3/12/15.
//  Copyright (c) 2015 mkrum. All rights reserved.
//

#import "ThreadListView.h"
@interface UIViewController ()

@end

@implementation ThreadListView

-(void) viewDidLoad{
    self.threads = [[NSMutableArray alloc]init];
    [self.threads addObject:@""];
    [self populateThreads];
}

-(void) populateThreads{
    self.query = [PFQuery queryWithClassName:@"area"];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
                [self.threads addObject:[object objectForKey:@"Name"]];
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




@end
