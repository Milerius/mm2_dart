#import <Flutter/Flutter.h>

@interface Mm2NativePlugin : NSObject<FlutterPlugin>
@end

//! mm2_main from libmm2.a
int8_t mm2_main (const char* conf, void (*log_cb) (const char* line));
int8_t mm2_main_status (void);