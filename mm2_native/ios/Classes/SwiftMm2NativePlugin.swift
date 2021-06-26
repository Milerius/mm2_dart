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
             case "mm2Start":
                os_log("mm2Start iOS", type: OSLogType.default)
                guard let mm2_cfg = (call.arguments as! Dictionary<String,String>)["mm2Arg"] else { result(1); return }
                result(Int32(mm2_main(mm2_cfg, { (line) in os_log("mm2 ios: %{public}@", type: OSLogType.default, String(cString: line!)) })))
            default:
                result(FlutterMethodNotImplemented)
            }
  }

   public func dummyMethodToEnforceBundling() {
        //! mm2_main instantiate
        let error = Int32(mm2_main("", { (line) in
                let mm2log = ["log": "AppDelegate] " + String(cString: line!)]
            }));

        //! mm2_status instantiate
        let res = Int32(mm2_main_status());
   }
}
