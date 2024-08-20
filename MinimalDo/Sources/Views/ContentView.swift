import SwiftUI

struct ContentView: View {
    @StateObject private var todoManager = TodoManager.mockManager

    var body: some View {
        Text("Hello, world!")
            .onAppear {
                printMockData()
                addMoreMockData()
                printMockData()
                removeMockList(listName: "Learning")
                printMockData()
            }
    }
}

#Preview {
    ContentView()
}
