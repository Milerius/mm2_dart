//! Dart packages
import 'dart:async';
import 'dart:ffi' as ffi; // For FFI
import 'dart:io'; // For Platform.isX
import 'dart:isolate';

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
    MM2MainStatus mainStatusFunctor = mm2NativeLib
        .lookup<ffi.NativeFunction<mm2_main_status_func>>("mm2_main_status")
        .asFunction();
    return mainStatusFunctor();
  }

  static void mm2Callback(ffi.Pointer<Utf8> str) {
    print('from mm2_callback: str=' + str.toString());
  }

  // function
  static int mm2Start() {
    String cfg =
        "{\"gui\":\"MM2GUI\",\"netid\":7777, \"userhome\":\"foo\", \"passphrase\":\"YOUR_PASSPHRASE_HERE\", \"rpc_password\":\"YOUR_PASSWORD_HERE\"}";
    if (Platform.isIOS) {
      var arg = <String, String>{'mm2Arg': cfg};
      _channel.invokeMethod("mm2Start", arg);
    } else {
      MM2Start func = mm2NativeLib
          .lookup<ffi.NativeFunction<mm2_main_func>>("mm2_main")
          .asFunction();
      func(cfg.toNativeUtf8().cast(),
          ffi.Pointer.fromFunction<mm2_log_cb_func>(mm2Callback));
    }
    return 0;
  }
}
