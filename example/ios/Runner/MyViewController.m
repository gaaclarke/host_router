//
//  MyViewController.m
//  Runner
//
//  Created by Aaron Clarke on 6/5/20.
//

#import "MyViewController.h"
#import "AppDelegate.h"
@import host_router;

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)onDismiss:(id)sender {
  AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
  [appDelegate.hostRouterPlugin pop];
}

-(IBAction)onPush:(id)sender {
  AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
  [appDelegate.hostRouterPlugin push:@"/page4"];
}

@end
