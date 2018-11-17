#import "AwareframeworkAccelerometerPlugin.h"
#import <awareframework_accelerometer/awareframework_accelerometer-Swift.h>

@implementation AwareframeworkAccelerometerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkAccelerometerPlugin registerWithRegistrar:registrar];
}

@end
