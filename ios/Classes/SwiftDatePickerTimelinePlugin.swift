import Flutter
import UIKit

public class SwiftDatePickerTimelinePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "date_picker_timeline_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftDatePickerTimelinePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
