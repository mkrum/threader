//
//  postView.h
//  threader
//
//  Created by Michael Krumdick on 3/23/15.
//  Copyright (c) 2015 mkrum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface postView : UITableViewController
@property NSString *name;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *add;

@end
