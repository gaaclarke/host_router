#import <Flutter/Flutter.h>

typedef void (^HostRouterHandler)(NSString* name);

@interface HostRouterPlugin : NSObject<FlutterPlugin>
@property(nonatomic, copy) HostRouterHandler handler;
@end
