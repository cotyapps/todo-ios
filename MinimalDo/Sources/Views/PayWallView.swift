import SwiftUI
import KovaleeSDK
import KovaleeFramework
import KovaleePurchases

struct PayWallView: View {
    @Binding var displayPaywall: Bool
    @State private var offeringPackages: [Package] = []
    @State private var selectedPackageIndex: Int?

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Text("MinimalDo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("PRO")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }.padding(.bottom, 50)
                Spacer()
                VStack(spacing: 15) {
                    ForEach(Array(offeringPackages.enumerated()), id: \.element.identifier) { index, package in
                        PayWallButton(
                            isSelected: Binding(
                                get: { selectedPackageIndex == index },
                                set: { _ in selectedPackageIndex = index }
                            ),
                            package: package
                        )
                    }
                }
                .padding(.bottom, 40)
                .padding(.horizontal, 20)
                VStack {
                    Button(action: {
                        // Implement purchase action
                    }, label: {
                        Text("Continue")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(100)
                    })
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    Button(action: {
                        // Implement restore action
                    }, label: {
                        Text("Restore")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.gray)
                    })
                }
                .padding(.bottom, 20)
            }
            .edgesIgnoringSafeArea(.all)
            .toolbar {
                Button("Close") {
                    displayPaywall.toggle()
                }
                .font(.headline)
                .foregroundColor(.gray)
            }
        }
        .onAppear {
            Kovalee.sendEvent(event: TaggingPlanLiteEvent.pageViewPaywall(source: "in_content"))
            retrieveOffering()
        }
    }

    @MainActor
    func retrieveOffering() {
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
}

struct PayWallButton: View {
    @Binding var isSelected: Bool
    let package: Package

    var body: some View {
        Button(action: {
            isSelected = true
        }, label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(getPackageTitle(identifier: package.identifier) ?? "")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    Text("\(package.localizedPriceString) / \(getPackageDurationString(duration: package.getDuration()) ?? "")")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.5), lineWidth: 2)
            )
        })
    }
}

#Preview {
    @State var displayPaywall = true
    return PayWallView(displayPaywall: $displayPaywall)
}
