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
    NSLog(@"%@",self.name.text);
    [self.name resignFirstResponder];
    return YES;
}

@end


