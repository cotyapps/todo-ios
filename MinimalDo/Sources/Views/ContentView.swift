import SwiftUI

struct ContentView: View {
    @State private var todoManager = TodoManager(lists: TodoList.mockTodoLists)
    @State private var showingNewListAlert = false
    @State private var newListName = ""
    @State private var showingDeleteAlert = false

    var body: some View {
        NavigationStack {
            List {
                ForEach($todoManager.lists) { $todoList in
                    NavigationLink(destination: ListView(todoList: $todoList)) {
                        Text(todoList.name)
                    }
                }
                .onDelete { offsets in
                    deleteList(at: offsets)
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
                        confirmAddList()
                    }
                }
            }
        }
    }

    private func confirmAddList() {
        guard !newListName.isEmpty else {
            return
        }
        let newTodoList = TodoList(name: newListName)
        todoManager.addList(newTodoList)
    }

    private func deleteList(at offsets: IndexSet) {
        todoManager.removeList(at: offsets)
    }
}

#Preview {
    ContentView()
}
