import SwiftUI

struct ContentView: View {
    @StateObject private var todoManager = TodoManager()

    var body: some View {
        Text("Hello, world!")
    }
}

#Preview {
    ContentView()
}
