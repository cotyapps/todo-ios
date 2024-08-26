import SwiftUI

struct ContentView: View {
    @State private var todoManager = TodoManager(lists: TodoList.mockTodoLists)
    @State private var showingNewListAlert = false
    @State private var newListName = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach($todoManager.lists) { $todoList in
                    NavigationLink(destination: ListView(todoList: $todoList)) {
                        Text(todoList.name)
                    }
                }
            }
            .navigationTitle("Minimal Todo")
            .toolbar {
                Button("New list", systemImage: "plus") {
                    newListName = ""
                    showingNewListAlert = true
                }
                .alert("Add new todo list", isPresented: $showingNewListAlert) {
                    TextField("Enter list name", text: $newListName)
                    Button("Cancel", role: .cancel) {}
                    Button("Confirm") {
                        guard !newListName.isEmpty else {
                            return
                        }
                        confirmAddList()
                    }
                }
            }
        }
    }

    private func confirmAddList() {
        let newTodoList = TodoList(name: newListName)
        todoManager.addList(newTodoList)
    }
}

#Preview {
    ContentView()
}
