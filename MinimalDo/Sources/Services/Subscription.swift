import Foundation
import KovaleePurchases
import KovaleeSDK

public class SubscriptionManager: ObservableObject {
    @Published var offeringPackages: [Package] = []
    @Published var selectedPackageIndex: Int?
    @Published var purchaseState: PurchaseState = .idle
    @Published var errorMessage: String?
    
    public init() {}
    
    @MainActor
    public func retrieveOffering() {
        Task {
            guard let offering = try? await Kovalee.fetchCurrentOffering() else {
                return
            }
            offeringPackages = offering.availablePackages
            if !offeringPackages.isEmpty {
                selectedPackageIndex = 0
            }
        }
    }
    
    @MainActor
    public func purchase(package: Package) async -> Bool {
        purchaseState = .loading
        do {
            guard let resultData = try await Kovalee.purchase(package: package, fromSource: "paywall") else {
                throw NSError(domain: "PayWallError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Purchase failed: No result data"])
            }
            if resultData.userCancelled {
                purchaseState = .idle
                return false
            }
            let isUserPremium = !resultData.customerInfo.activeSubscriptions.isEmpty
            purchaseState = .idle
            return isUserPremium
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            purchaseState = .idle
            return false
        }
    }
    
    @MainActor
    public func restorePurchases() async -> Bool {
        purchaseState = .loading
        do {
            guard let data = try await Kovalee.restorePurchases(fromSource: "paywall") else {
                throw NSError(domain: "PayWallError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Restore failed"])
            }
            let isUserPremium = !data.activeSubscriptions.isEmpty
            if !isUserPremium {
                errorMessage = "No active subscriptions found."
            }
            purchaseState = .idle
            return isUserPremium
        } catch {
            errorMessage = "Restore failed: \(error.localizedDescription)"
            purchaseState = .idle
            return false
        }
    }
    
    public func checkIfSubscribed() async -> Bool {
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
}

public enum PurchaseState {
    case idle
    case loading
}

public struct SubscriptionErrorWrapper: Identifiable {
    public let id = UUID()
    public let error: String
}
