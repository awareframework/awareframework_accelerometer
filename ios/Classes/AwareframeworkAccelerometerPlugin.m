#import "AwareframeworkAccelerometerPlugin.h"
#if __has_include(<awareframework_accelerometer/awareframework_accelerometer-Swift.h>)
#import <awareframework_accelerometer/awareframework_accelerometer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "awareframework_accelerometer-Swift.h"
#endif

@implementation AwareframeworkAccelerometerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkAccelerometerPlugin registerWithRegistrar:registrar];
}
@end
