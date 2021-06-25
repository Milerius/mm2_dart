#import "Mm2NativePlugin.h"
#if __has_include(<mm2_native/mm2_native-Swift.h>)
#import <mm2_native/mm2_native-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "mm2_native-Swift.h"
#endif

@implementation Mm2NativePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMm2NativePlugin registerWithRegistrar:registrar];
}
@end
