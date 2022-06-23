import UIKit
import Flutter
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    FirebaseApp.configure()
    return true
  }
}

///////-----////////

// import UIKit
// import FirebaseCore
//
// @UIApplicationMain
// class AppDelegate: UIResponder, UIApplicationDelegate {
//
//   var window: UIWindow?
//
//   func application(_ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions:
//       [UIApplication.LaunchOptionsKey:: Any]?) -> Bool {
//     FirebaseApp.configure()
//
//     return true
//   }
// }