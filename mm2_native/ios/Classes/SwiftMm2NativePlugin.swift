import Flutter
import UIKit
import os.log

public class SwiftMm2NativePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "mm2_native", binaryMessenger: registrar.messenger())
    let instance = SwiftMm2NativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "getPlatformVersion":
            os_log("getPlatformVersion iOS", type: OSLogType.default)
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterMethodNotImplemented)
        }
  }

   public func dummyMethodToEnforceBundling() {
        let error = Int32(mm2_main("", { (line) in
                let mm2log = ["log": "AppDelegate] " + String(cString: line!)]
            }));

        let res = Int32(mm2_main_status());
   }
}
