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
            print("Permission approved!")
            Kovalee.sendEvent(Event(name: "na_notification_activate"))
        } else {
            print("Permission denied or request failed")
            Kovalee.sendEvent(Event(name: "na_notification_deactivate"))

            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
