import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyCfwENJ0JLVmBIc7z4a-4NONyjI3E6G-lE")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
