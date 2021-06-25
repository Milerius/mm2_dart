//! Dart packages
import 'dart:async';
import 'dart:ffi'; // For FFI
import 'dart:io'; // For Platform.isX

//! Flutter packages
import 'package:flutter/services.dart';
import 'package:ffi/ffi.dart';

final DynamicLibrary mm2NativeLib = Platform.isAndroid
    ? DynamicLibrary.open("libmm2.so")
    : DynamicLibrary.process();

//int8_t mm2_main (const char* conf, void (*log_cb) (const char* line));
typedef Mm2LogCB = Void Function(Pointer<Utf8>);
typedef Mm2Start = Int8 Function(Pointer<Utf8> conf, Pointer<NativeFunction<Mm2LogCB>>);
typedef MM2Start = int Function(Pointer<Utf8> conf, Pointer<NativeFunction<Mm2LogCB>>);

class Mm2Native {
  static const MethodChannel _channel =
      const MethodChannel('mm2_native');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void mm2Callback(Pointer<Utf8> str) {
    print('from mm2_callback: str=$str');
  }

  // function
  static int mm2Start() {
    //await _channel.invokeMethod('mm2Start');
    MM2Start func = mm2NativeLib.lookup<NativeFunction<Mm2Start>>("mm2_main").asFunction();
    String foo = "";
    func(foo.toNativeUtf8(), Pointer.fromFunction<Mm2LogCB>(mm2Callback));
    return 0;
  }
}
