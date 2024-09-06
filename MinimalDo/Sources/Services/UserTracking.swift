import AppTrackingTransparency
import Foundation
import KovaleeFramework
import KovaleeSDK

func handleTrackingAuthorizationStatus(_ status: ATTrackingManager.AuthorizationStatus) {
    switch status {
    case .authorized:
        Kovalee.sendEvent(event: .naAttActivate)
    case .denied, .restricted:
        Kovalee.sendEvent(event: .naAttDeactivate)
    case .notDetermined:
        print("Tracking authorization status is not determined")
    @unknown default:
        print("Tracking authorization status it unknown")
    }
}
