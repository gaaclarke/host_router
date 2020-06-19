#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
@import host_router;
#import "MyViewController.h"

@interface AppDelegate ()
@property(nonatomic, strong) UINavigationController* navigationController;
@property(nonatomic, weak) HostRouterPlugin* hostRouterPlugin;
@property(nonatomic, strong) FlutterViewController* flutterViewController;
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  UIViewController* rootViewController = self.window.rootViewController;
  id<FlutterPluginRegistry> registry = self;
  if  ([rootViewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController* navigationController = (id)rootViewController;
    self.navigationController = navigationController;
    if ([navigationController.topViewController isKindOfClass:[FlutterViewController class]]) {
      FlutterViewController *vc =  (id)navigationController.topViewController;
      self.flutterViewController = vc;
      registry = vc.pluginRegistry;
    }
  }
  [GeneratedPluginRegistrant registerWithRegistry:registry];
  NSObject *published = [registry valuePublishedByPlugin:@"HostRouterPlugin"];
  if ([published isKindOfClass:[HostRouterPlugin class]]) {
    HostRouterPlugin *plugin = (HostRouterPlugin *)published;
    self.hostRouterPlugin = plugin;
    plugin.pushHostHandler = ^(NSString *name) {
      if ([name isEqualToString:@"/page3"]) {
        MyViewController* myViewController = [[MyViewController alloc] init];
        [self.navigationController pushViewController:myViewController animated:YES];
      } else {
        NSLog(@"unrecognized path: %@", name);
      }
    };
    plugin.pushFlutterHandler = ^(NSString *name) {
      if (![self.navigationController.topViewController isKindOfClass:[FlutterViewController class]]) {
        FlutterEngine* engine = self.flutterViewController.engine;
        engine.viewController = nil;
        FlutterViewController* vc = [[FlutterViewController alloc] initWithEngine:self.flutterViewController.engine nibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
      }
    };
    plugin.popHandler = ^(NSString *name) {
      [self.navigationController popViewControllerAnimated:YES];
    };
  }

  return [super application:application
      didFinishLaunchingWithOptions:launchOptions];
}

@end
