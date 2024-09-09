import Foundation

public enum SubscriptionStatus {
    case weekly
    case monthly
    case yearly
    case non
}

public var subscriptionStatus = SubscriptionStatus.non

public func checkIfSubscribe() -> Bool {
    return subscriptionStatus != SubscriptionStatus.non
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
