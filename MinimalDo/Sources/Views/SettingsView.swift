import SwiftUI
import KovaleeSDK
import KovaleeFramework

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Premium")
                        Spacer()
                        Text("No").foregroundColor(.gray)
                    }
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0").foregroundColor(.gray)
                    }
                    HStack {
                        Text("SDK Version")
                        Spacer()
                        Text("1.10.6").foregroundColor(.gray)
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
        }
    }
}

#Preview {
    SettingsView()
}
