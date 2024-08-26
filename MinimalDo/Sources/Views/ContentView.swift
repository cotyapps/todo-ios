import SwiftUI

struct ContentView: View {
    @State private var todoManager = TodoManager(lists: TodoList.mockTodoLists)
    @State private var showingNewListAlert = false
    @State private var newListName = ""
    @State private var showingDeleteAlert = false
    @State private var listToDelete: IndexSet?

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array($todoManager.lists.enumerated()), id: \.offset) { index, $todoList in
                    NavigationLink(destination: ListView(todoList: $todoList)) {
                        Text(todoList.name)
                            .swipeActions(allowsFullSwipe: true) {
                                Button {
                                    listToDelete = IndexSet(integer: index)
                                    showingDeleteAlert = true
                                } label: {
                                    Image(systemName: "trash.fill")
                                }
                                .tint(.red)
                            }
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
                        confirmAddList()
                    }
                }
            }
            .alert("Confirm delete?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    deleteList(at: listToDelete)
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

    private func deleteList(at offsets: IndexSet?) {
        guard let offsets = offsets else {
            return
        }
        todoManager.removeList(at: offsets)
    }
}

#Preview {
    ContentView()
}
