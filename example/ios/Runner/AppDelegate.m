#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
@import host_router;
#import "MyViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  NSObject *published = [self valuePublishedByPlugin:@"HostRouterPlugin"];
  if ([published isKindOfClass:[HostRouterPlugin class]]) {
    HostRouterPlugin *plugin = (HostRouterPlugin *)published;
    plugin.handler = ^(NSString *name) {
      if ([name isEqualToString:@"/page3"]) {
        MyViewController* myViewController = [[MyViewController alloc] init];
        UIViewController *vc = [[[UIApplication sharedApplication] windows][0] rootViewController];
        [vc presentViewController:myViewController animated:YES completion:nil];
      } else {
        NSLog(@"unrecognized path: %@", name);
      }
    };
  }

  return [super application:application
      didFinishLaunchingWithOptions:launchOptions];
}

@end
