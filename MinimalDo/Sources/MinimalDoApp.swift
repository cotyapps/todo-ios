import AppTrackingTransparency
import KovaleeAttribution
import KovaleeFramework
import KovaleeSDK
import SwiftUI

@main
struct MinimalDoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    Task {
                        let notificationAllowed = await isNotificationAllowed()
                        if notificationAllowed {
                            Kovalee.setUserProperty(prop: .pushNotificationAllowed(true))
                        } else {
                            Kovalee.setUserProperty(prop: .pushNotificationAllowed(false))
                        }
                    }

                    guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else {
                        return
                    }
                    Task {
                        let status = await Kovalee.promptTrackingAuthorization()
                        handleTrackingAuthorizationStatus(status)
                    }
                }
        }
    }
}
