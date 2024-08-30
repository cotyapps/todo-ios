import Foundation

public enum SubscriptionStatus {
    case monthly
    case yearly
    case non
}

public var subscriptionStatus = SubscriptionStatus.non

public func checkIfSubscribe() -> Bool {
    return subscriptionStatus != SubscriptionStatus.non
}
