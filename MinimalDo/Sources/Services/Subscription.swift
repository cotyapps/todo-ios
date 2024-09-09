import Foundation
import KovaleePurchases
import KovaleeSDK

public func checkIfSubscribe() async throws -> Bool {
    do {
        if let customerInfo = try await Kovalee.customerInfo() {
            return !customerInfo.activeSubscriptions.isEmpty
        } else {
            return false
        }
    } catch {
        print("Error checking subscription: \(error)")
        return false
    }
}
public func getPackageTitle(identifier: String) -> String? {
    switch identifier {
    case "$rc_monthly":
        return "Monthly Subscription"
    case "$rc_annual":
        return "Yearly Subscription"
    default:
        return nil
    }
}

public func getPackageDurationString(duration: Int) -> String? {
    switch duration {
    case 30:
        return "month"
    case 365:
        return "year"
    default:
        return nil
    }
}

enum PurchaseState {
    case idle
    case loading
}

struct SubscriptionErrorWrapper: Identifiable {
    let id = UUID()
    let error: String
}
