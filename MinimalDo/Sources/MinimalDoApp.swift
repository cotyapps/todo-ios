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

                    if checkIfSubscribe() {
                        Kovalee.setUserProperty(prop: .premium(true))
                    } else {
                        Kovalee.setUserProperty(prop: .premium(false))
                    }

                    if !hasLaunchedBefore {
                        Kovalee.sendEvent(event: .firstAppOpen)
                        hasLaunchedBefore = true
                    } else {
                        Kovalee.sendEvent(event: .appOpen)
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
