import AppTrackingTransparency
import KovaleeAttribution
import KovaleeSDK
import SwiftUI

@main
struct MinimalDoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else {
                        return
                    }

                    Task {
                        await Kovalee.promptTrackingAuthorization()
                    }
                } 
        }
    }
}
