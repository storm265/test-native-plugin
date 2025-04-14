import Flutter
import UIKit
import flutter_background_service_ios // add this

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     /// Add this line
    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "com.example.helloExample676"
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
