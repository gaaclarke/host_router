#import "HostRouterPlugin.h"
#import "messages.h"

@interface HostRouterPlugin () <HRHostRouterApi>
@property(nonatomic, strong) HRFlutterRouterApi* flutterApi;
@end


@implementation HostRouterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  HostRouterPlugin* plugin = [[HostRouterPlugin alloc] initWithMessenger:registrar.messenger];
  [registrar publish:plugin];
  HRHostRouterApiSetup(registrar.messenger, plugin);
}

-(instancetype)initWithMessenger:(id<FlutterBinaryMessenger>)messenger {
  self = [super init];
  if (self) {
    _flutterApi = [[HRFlutterRouterApi alloc] initWithBinaryMessenger:messenger];
  }
  return self;
}

-(void)pushRoute:(HRPushRoute*)input error:(FlutterError *_Nullable *_Nonnull)error {
  if (self.pushHandler) {
    self.pushHandler(input.name);
  } else {
    *error = [FlutterError errorWithCode:@"HostRouterPlugin" message:@"no handler set" details:nil];
  }
}

-(void)popRoute:(HRPopRoute*)input error:(FlutterError *_Nullable *_Nonnull)error {
  if (self.popHandler) {
    self.popHandler(input.name);
  } else {
    *error = [FlutterError errorWithCode:@"HostRouterPlugin" message:@"no handler set" details:nil];
  }
}

-(void)pop {
  NSError* error;
  HRPopRoute* popRoute = [[HRPopRoute alloc] init];
  [self popRoute:popRoute error:&error];
//  [_flutterApi popRoute:^(NSError * _Nonnull error) {
//    if (error != nil) {
//      NSLog(@"error: %@", error);
//    }
//  }];
}

-(void)push:(NSString*)path {
  HRPushRoute* pushRoute = [[HRPushRoute alloc] init];
  pushRoute.name = path;
  [_flutterApi pushRoute:pushRoute completion:^(NSError* error) {
    if (error != nil) {
      NSLog(@"error: %@", error);
    }
  }];
}

@end
