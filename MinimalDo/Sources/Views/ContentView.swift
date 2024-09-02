import SwiftUI

struct ContentView: View {
    @State private var todoManager = TodoManager(lists: TodoList.mockTodoLists)
    @State private var showingListAlert = false
    @State private var newListName = ""
    @State private var chosenList: IndexSet?
    @State private var displayPaywall = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array($todoManager.lists.enumerated()), id: \.offset) { index, $todoList in
                    NavigationLink(destination: ListView(todoList: $todoList)) {
                        Text(todoList.name)
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    let offsets = IndexSet(integer: index)
                                    deleteList(at: offsets)
                                } label: {
                                    Image(systemName: "trash.fill")
                                }

                                Button {
                                    newListName = todoList.name
                                    chosenList = IndexSet(integer: index)
                                    showingListAlert = true
                                } label: {
                                    Image(systemName: "pencil")
                                }
                            }
                    }
                }
            }
            .navigationTitle("Minimal Todo")
            .toolbar {
                Button("New list", systemImage: "plus") {
                    newListName = ""
                    chosenList = nil
                    if !todoManager.canAddList() {
                        displayPaywall.toggle()
                    } else {
                        showingListAlert = true
                    }
                }
            }
            .alert(chosenList == nil ? "Add new todo list" : "Edit list name", isPresented: $showingListAlert) {
                TextField("Enter new list name", text: $newListName)
                Button("Cancel", role: .cancel) {}
                Button("Confirm") {
                    if let chosenList = chosenList {
                        editListName(at: chosenList, newName: newListName)
                    } else {
                        confirmAddList()
                    }
                }
            }
            .sheet(isPresented: $displayPaywall, content: {
                PayWallView(displayPaywall: $displayPaywall)
            })
        }
    }

    private func confirmAddList() {
        guard !newListName.isEmpty else {
            return
        }
        let newTodoList = TodoList(name: newListName)
        todoManager.addList(newTodoList)
    }
    private func editListName(at offsets: IndexSet?, newName: String) {
        guard let offsets = offsets, !newName.isEmpty else {
            return
        }
        todoManager.changeListName(at: offsets, newName: newName)
    }

    private func deleteList(at offsets: IndexSet) {
        todoManager.removeList(at: offsets)
    }
}

#Preview {
    ContentView()
}
