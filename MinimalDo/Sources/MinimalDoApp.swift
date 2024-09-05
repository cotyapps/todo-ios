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
                            Kovalee.setUserProperty(key: "push_notification_allowed", value: "yes")
                        } else {
                            Kovalee.setUserProperty(key: "push_notification_allowed", value: "no")
                        }
                    }

                    if checkIfSubscribe() {
                        Kovalee.setUserProperty(key: "premium", value: "yes")
                    } else {
                        Kovalee.setUserProperty(key: "premium", value: "no")
                    }

                    if !hasLaunchedBefore {
                        Kovalee.sendEvent(Event(name: "first_app_open"))
                        hasLaunchedBefore = true
                    } else {
                        Kovalee.sendEvent(Event(name: "app_open"))
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
