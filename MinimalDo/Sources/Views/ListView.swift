import SwiftUI

struct ListView: View {
    @Binding var todoList: TodoList
    @State private var showingAddItem = false

    var body: some View {
        List {
            ForEach($todoList.todoItems.filter { !$0.wrappedValue.isDone }) { $todoItem in
                ElementView(todoItem: $todoItem)
            }
        }
        .navigationTitle("\(todoList.name)")
        .toolbar {
            Button("Add Item", systemImage: "plus") {
                showingAddItem = true
            }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView(todoList: $todoList)
        }
    }
}

#Preview {
    @State var personalList = TodoList.mockTodoLists[1]
    return NavigationStack {
        ListView(todoList: $personalList)
    }
}
