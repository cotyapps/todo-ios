import UIKit
import KovaleeSDK

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Kovalee.initialize(
            configuration: Configuration(
                environment: .development,
                logLevel: .debug
            )
        )

        return true
    }
}
