import Foundation
import KovaleeFramework
import KovaleeSDK
import UserNotifications

private let notiCenter = UNUserNotificationCenter.current()

public func isNotificationAllowed() async -> Bool {
    let settings = await notiCenter.notificationSettings()
    return settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
}

public func askUserAuthorizationForNotification() {
    notiCenter.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            Kovalee.sendEvent(event: .naNotificationActivate)
        } else {
            Kovalee.sendEvent(event: .naNotificationDeactivate)

            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
