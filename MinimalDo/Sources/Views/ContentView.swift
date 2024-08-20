import SwiftUI

struct ContentView: View {
    @StateObject private var todoManager = TodoManager(lists: TodoList.mockTodoLists)

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
