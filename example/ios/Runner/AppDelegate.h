#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>

@class HostRouterPlugin;

@interface AppDelegate : FlutterAppDelegate
@property(nonatomic, readonly) UINavigationController* navigationController;
@property(nonatomic, weak, readonly) HostRouterPlugin* hostRouterPlugin;
@property(nonatomic, readonly) FlutterViewController* flutterViewController;
@end
