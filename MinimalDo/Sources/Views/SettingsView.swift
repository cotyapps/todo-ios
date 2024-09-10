import SwiftUI
import KovaleeSDK
import KovaleeFramework

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var subscriptionManager = SubscriptionManager()
    @State private var isPremium: Bool = false
    @State private var appVersion: String = ""

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Premium")
                        Spacer()
                        Text(isPremium ? "Yes" : "No").foregroundColor(.gray)
                    }
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text(appVersion).foregroundColor(.gray)
                    }
                    HStack {
                        Text("SDK Version")
                        Spacer()
                        Text(SDK_VERSION).foregroundColor(.gray)
                    }
                    HStack {
                        Text("AB Test Variant")
                        Spacer()
                        Text("0001").foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            Kovalee.sendEvent(event: .pageView(screen: "settings"))
            Task {
                await checkSubscriptionStatus()
            }
            fetchAppVersion()
        }
    }
    private func checkSubscriptionStatus() async {
        isPremium = await subscriptionManager.checkIfSubscribed()
    }
    
    private func fetchAppVersion() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        } else {
            appVersion = "Unknown"
        }
    }
}

#Preview {
    SettingsView()
}
