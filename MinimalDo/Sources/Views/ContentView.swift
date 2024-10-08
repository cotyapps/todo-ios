import KovaleeSDK
import KovaleeFramework
import SwiftUI
import KovaleeRemoteConfig

struct ContentView: View {
    @State private var todoManager = TodoManager()
    @State private var showingListAlert = false
    @State private var newListName = ""
    @State private var chosenList: IndexSet?
    @State private var displayPaywall = false
    @State private var showingSettings = false
    @StateObject private var abTestManager = ABTestManager.shared

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
			.onAppear {
				Kovalee.sendEvent(event: .pageView(screen: "home"))
			}
            .navigationTitle("Minimal Todo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button("New list", systemImage: "plus") {
                            Task {
                                newListName = ""
                                chosenList = nil
                                let canAdd = await todoManager.canAddList()
                                if !canAdd {
                                    displayPaywall = true
                                } else {
                                    showingListAlert = true
                                }
                            }
                        }

                        Button(action: {
                            showingSettings = true
                        }, label: {
                            Image(systemName: "gear")
                        })
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
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("TodoItemToggled"))) { _ in
            todoManager.loadList()
        }
        .task {
            await abTestManager.fetchABTestValue()
        }
    }

    private func confirmAddList() {
        guard !newListName.isEmpty else {
            return
        }
        let newTodoList = TodoList(name: newListName)
        todoManager.addList(newTodoList)
        Kovalee.sendEvent(event: .acTodoListCreated)
    }
    private func editListName(at offsets: IndexSet?, newName: String) {
        guard let offsets = offsets, !newName.isEmpty else {
            return
        }
        todoManager.changeListName(at: offsets, newName: newName)
        Kovalee.sendEvent(event: .acTodoListEdited)
    }

    private func deleteList(at offsets: IndexSet) {
        todoManager.removeList(at: offsets)
        Kovalee.sendEvent(event: .acTodoListDeleted)
    }
}

#Preview {
    ContentView()
}
