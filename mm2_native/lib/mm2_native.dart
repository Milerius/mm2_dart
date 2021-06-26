//! Dart packages
import 'dart:async';
import 'dart:ffi' as ffi; // For FFI
import 'dart:io'; // For Platform.isX

//! Flutter packages
import 'package:flutter/services.dart';
import 'package:ffi/ffi.dart';

final ffi.DynamicLibrary mm2NativeLib = Platform.isAndroid
    ? ffi.DynamicLibrary.open("libmm2.so")
    : ffi.DynamicLibrary.process();

//int8_t mm2_main (const char* conf, void (*log_cb) (const char* line));
typedef mm2_log_cb_func = ffi.Void Function(ffi.Pointer<Utf8> line);
typedef mm2_main_func = ffi.Int8 Function(
    ffi.Pointer<Utf8> conf, ffi.Pointer<ffi.NativeFunction<mm2_log_cb_func>>);
typedef MM2Start = int Function(
    ffi.Pointer<Utf8> conf, ffi.Pointer<ffi.NativeFunction<mm2_log_cb_func>>);

//! int8_t mm2_main_status (void);
typedef mm2_main_status_func = ffi.Int8 Function();
typedef MM2MainStatus = int Function();

class Mm2Native {
  static const MethodChannel _channel = const MethodChannel('mm2_native');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static int mm2Status() {
    print('before mm2 status');
    MM2MainStatus func = mm2NativeLib
        .lookup<ffi.NativeFunction<mm2_main_status_func>>("mm2_main_status")
        .asFunction();
    print('mm2_status function retrieved');
    int status = func();
    print('mm2_status retrieved');
    return status;
  }

  static void mm2Callback(ffi.Pointer<Utf8> str) {
    print('from mm2_callback: str=' + str.toString());
  }

  // function
  static int mm2Start() {
    //await _channel.invokeMethod('mm2Start');
    print('before mm2 start');
    MM2Start func = mm2NativeLib
        .lookup<ffi.NativeFunction<mm2_main_func>>("mm2_main")
        .asFunction();
    print(func.toString());
    print('mm2 main function retrieved');
    String cfg =
        "{\"gui\":\"MM2GUI\",\"netid\":7777, \"userhome\":\"foo\"}\", \"passphrase\":\"YOUR_PASSPHRASE_HERE\", \"rpc_password\":\"YOUR_PASSWORD_HERE\"}";
    func(cfg.toNativeUtf8().cast(),
        ffi.Pointer.fromFunction<mm2_log_cb_func>(mm2Callback));
    print('mm2 started');
    return 0;
  }
}
