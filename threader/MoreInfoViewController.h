//
//  MoreInfoViewController.h
//  threader
//
//  Created by Michael Krumdick on 3/19/15.
//  Copyright (c) 2015 mkrum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreInfoViewController : UIViewController <UITextFieldDelegate>
@property NSMutableArray *coordinates;
@property (weak, nonatomic) IBOutlet UITextField *name;

@end
