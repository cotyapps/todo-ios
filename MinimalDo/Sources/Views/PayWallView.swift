import SwiftUI

struct PayWallView: View {
    @Binding var displayPaywall: Bool
    @State var chosenOption = SubscriptionStatus.monthly

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
                    Button(action: {
                        chosenOption = SubscriptionStatus.monthly
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Primary Product")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                Text("$ 2.99 / month")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(chosenOption == SubscriptionStatus.monthly ? Color.blue.opacity(0.2) : Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(chosenOption == SubscriptionStatus.monthly
                                        ? Color.blue : Color.gray.opacity(0.5), lineWidth: 2)
                        )
                    }
                    Button(action: {
                        chosenOption = SubscriptionStatus.yearly
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Secondary Product")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                Text("$ 12.99 / year")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(chosenOption == SubscriptionStatus.yearly ? Color.blue.opacity(0.2) : Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(chosenOption == SubscriptionStatus.yearly
                                        ? Color.blue : Color.gray.opacity(0.5), lineWidth: 2)
                        )
                    }
                }
                .padding(.bottom, 40)
                .padding(.horizontal, 20)
                VStack {
                    Button(action: {
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                    Button(action: {
                    }) {
                        Text("Restore")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.gray)
                    }
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
    }
}

#Preview {
    @State var displayPaywall = true
    return PayWallView(displayPaywall: $displayPaywall)
}
