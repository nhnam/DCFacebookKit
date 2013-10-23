//
//  ViewController.m
//  DCFacebookKit
//
//  Created by Nam Nguyen on 10/15/13.
//  Copyright (c) 2013 namnguyen. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btPostText;
@property (strong, nonatomic) IBOutlet UITextField *textText;

@end

@implementation ViewController
@synthesize textText, btPostText;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [textText setHidden:YES];
    [btPostText setHidden:YES];
    if([FBSession activeSession].isOpen){
        [textText setHidden:NO];
        [btPostText setHidden:NO];
    }
    DLog(@"Run...");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTouchLoginButton:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DCFbKit sharedKit] login:^(BOOL status, NSObject *response) {
        DLog(@"Login callback response: %@", response);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([FBSession activeSession].isOpen){
            [textText setHidden:NO];
            [btPostText setHidden:NO];
        }
    }];
}
- (IBAction)didTouchPost:(id)sender {
    [[DCFbKit sharedKit] postText:[textText text] callback:^(BOOL status, NSObject *response) {
        DLog(@"Post text callback response: %@", response);
    }];
}

@end
