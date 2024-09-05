import SwiftUI
import KovaleeSDK
import KovaleeFramework

struct ListView: View {
    @Binding var todoList: TodoList
    @State private var showingAddEditItem = false
    @State private var editingItem: TodoItem?

    var body: some View {
        List {
            ForEach($todoList.todoItems.filter { !$0.wrappedValue.isDone }) { $todoItem in
                Button(action: {
                    openTodoItem(chosenTodo: todoItem)
                }, label: {
                    ElementView(todoItem: $todoItem)
                })
            }
        }
        .navigationTitle("\(todoList.name)")
        .toolbar {
            Button("Add Item", systemImage: "plus") {
                editingItem = nil
                showingAddEditItem = true
            }
        }
        .sheet(isPresented: $showingAddEditItem) {
            AddEditItemView(todoList: $todoList, editingItem: editingItem)
        }
        .onAppear {
            Kovalee.sendEvent(event: .pageView(screen: "todo_list"))
        }
    }

    private func openTodoItem(chosenTodo: TodoItem) {
        editingItem = chosenTodo
        showingAddEditItem.toggle()
    }
}

#Preview {
    @State var personalList = TodoList.mockTodoLists[1]
    return NavigationStack {
        ListView(todoList: $personalList)
    }
}
