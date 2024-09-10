import SwiftUI
import KovaleeSDK
import KovaleeFramework
import KovaleePurchases

struct PayWallView: View {
    @Binding var displayPaywall: Bool
    @StateObject private var subscriptionManager = SubscriptionManager()
    
    var body: some View {
        NavigationView {
            ZStack {
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
                        ForEach(Array(subscriptionManager.offeringPackages.enumerated()), id: \.element.identifier) { index, package in
                            PayWallButton(
                                isSelected: Binding(
                                    get: { subscriptionManager.selectedPackageIndex == index },
                                    set: { _ in subscriptionManager.selectedPackageIndex = index }
                                ),
                                package: package,
                                getPackageTitle: subscriptionManager.getPackageTitle,
                                getPackageDurationString: subscriptionManager.getPackageDurationString
                            )
                        }
                    }
                    .padding(.bottom, 40)
                    .padding(.horizontal, 20)
                    VStack {
                        Button(action: {
                            if let index = subscriptionManager.selectedPackageIndex,
                               index < subscriptionManager.offeringPackages.count {
                                Task {
                                    let success = await subscriptionManager.purchase(package: subscriptionManager.offeringPackages[index])
                                    if success {
                                        displayPaywall = false
                                    }
                                }
                            }
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
                        .disabled(subscriptionManager.purchaseState == .loading)
                        Button(action: {
                            Task {
                                let success = await subscriptionManager.restorePurchases()
                                if success {
                                    displayPaywall = false
                                }
                            }
                        }, label: {
                            Text("Restore")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.gray)
                        })
                        .disabled(subscriptionManager.purchaseState == .loading)
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
                if subscriptionManager.purchaseState == .loading {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                }
            }
        }
        .onAppear {
            Kovalee.sendEvent(event: TaggingPlanLiteEvent.pageViewPaywall(source: "in_content"))
            subscriptionManager.retrieveOffering()
        }
        .alert(item: Binding(
            get: { subscriptionManager.errorMessage.map { SubscriptionErrorWrapper(error: $0) } },
            set: { subscriptionManager.errorMessage = $0?.error }
        )) { errorWrapper in
            Alert(title: Text("Error"), message: Text(errorWrapper.error), dismissButton: .default(Text("OK")))
        }
    }
}

struct PayWallButton: View {
    @Binding var isSelected: Bool
    let package: Package
    let getPackageTitle: (String) -> String?
    let getPackageDurationString: (Int) -> String?

    var body: some View {
        Button(action: {
            isSelected = true
        }, label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(getPackageTitle(package.identifier) ?? "")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    Text("\(package.localizedPriceString) / \(getPackageDurationString(package.getDuration()) ?? "")")
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
