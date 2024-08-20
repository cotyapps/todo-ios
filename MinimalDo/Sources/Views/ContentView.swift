import SwiftUI

struct ContentView: View {
    @StateObject var todoManager = TodoManager()

    init() {
        let manager = TodoManager()
        manager.lists = TodoList.mockTodoLists
        _todoManager = StateObject(wrappedValue: manager)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(todoManager.lists) { todoList in
                    NavigationLink {
                        ListView(todoList: todoList)
                    } label: {
                        Text("\(todoList.name)")
                    }
                }
            }
            .navigationTitle("Minimal Todo")
        }
    }
}

#Preview {
    ContentView()
}
