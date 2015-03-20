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
    NSLog(@"%@",self.name.text);
    PFObject *area = [PFObject objectWithClassName:@"area"];
    [area setObject:_coordinates forKey:@"coordinates"];
    [area setObject: self.name.text forKey:@"Name"];
    [area saveInBackground];

    [self.name resignFirstResponder];
    return YES;
}

@end


