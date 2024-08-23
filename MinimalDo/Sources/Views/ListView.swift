import SwiftUI

struct ListView: View {
    @Binding var todoList: TodoList
    @State private var showingAddEditItem = false
    @State private var editingItem: TodoItem?

    var body: some View {
        List {
            ForEach($todoList.todoItems.filter { !$0.wrappedValue.isDone }) { $todoItem in
                ElementView(todoItem: $todoItem, showingEditItem: $showingAddEditItem, editingItem: $editingItem)
            }
        }
        .navigationTitle("\(todoList.name)")
        .toolbar {
            Button("Add Item", systemImage: "plus") {
                showingAddEditItem = true
            }
        }
        .sheet(isPresented: $showingAddEditItem) {
            if let editingItem = editingItem {
                AddEditItemView(todoList: $todoList, editingItem: editingItem)
            } else {
                AddEditItemView(todoList: $todoList)
            }
        }
    }
}

#Preview {
    @State var personalList = TodoList.mockTodoLists[1]
    return NavigationStack {
        ListView(todoList: $personalList)
    }
}
