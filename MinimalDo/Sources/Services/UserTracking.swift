import AppTrackingTransparency
import Foundation
import KovaleeFramework
import KovaleeSDK

func handleTrackingAuthorizationStatus(_ status: ATTrackingManager.AuthorizationStatus) {
    switch status {
    case .authorized:
        Kovalee.sendEvent(Event(name: "na_att_activate"))
    case .denied, .restricted:
        Kovalee.sendEvent(Event(name: "na_att_deactivate"))
    case .notDetermined:
        print("Tracking authorization status is not determined")
    @unknown default:
        print("Tracking authorization status it unknown")
    }
}
