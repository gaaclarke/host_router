#import "HostRouterPlugin.h"
#import "messages.h"

@interface HostRouterPlugin () <HRHostRouterApi>
@end


@implementation HostRouterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  HostRouterPlugin* plugin = [[HostRouterPlugin alloc] init];
  [registrar publish:plugin];
  HRHostRouterApiSetup(registrar.messenger, plugin);
}

-(void)pushRoute:(HRPushRoute*)input error:(FlutterError *_Nullable *_Nonnull)error {
  if (self.handler) {
    self.handler(input.name);
  } else {
    *error = [FlutterError errorWithCode:@"HostRouterPlugin" message:@"no handler set" details:nil];
  }
}
@end
