#import <Flutter/Flutter.h>

typedef void (^HostRouterHandler)(NSString* name);

@interface HostRouterPlugin : NSObject<FlutterPlugin>
@property(nonatomic, copy) HostRouterHandler pushHandler;
@property(nonatomic, copy) HostRouterHandler popHandler;
-(void)pop;
-(void)push:(NSString*)path;
@end
