import Foundation
import KovaleeSDK
import KovaleeRemoteConfig

class ABTestManager: ObservableObject {
    @Published var currentABTest: String?
    
    static let shared = ABTestManager()
    
    private init() {}
    
    func fetchABTestValue() async {
        currentABTest = await Kovalee.abTestValue() ?? "0000"
    }
    
    func getABTestValue() -> String {
        return currentABTest ?? "Unknown"
    }
}
