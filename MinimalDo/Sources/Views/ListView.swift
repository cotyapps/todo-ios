import SwiftUI

struct ListView: View {
    @Binding var todoList: TodoList

    var body: some View {
        List {
            ForEach($todoList.todoItems) { $todoItem in
                ElementView(todoItem: $todoItem)
            }
        }
        .navigationTitle("\(todoList.name)")
    }
}

#Preview {
    @State var personalList = TodoList.mockTodoLists[1]
    return NavigationStack {
        ListView(todoList: $personalList)
    }
}
