
import 'dart:async';

import 'package:flutter/services.dart';

class Mm2Native {
  static const MethodChannel _channel =
      const MethodChannel('mm2_native');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
