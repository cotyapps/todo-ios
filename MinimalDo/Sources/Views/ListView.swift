import SwiftUI

struct ListView: View {
    let todoList: TodoList
    var body: some View {
        List {
            ForEach(todoList.todoItems) { todoItem in
                HStack {
                    Image(systemName: todoItem.isDone
                          ? "largecircle.fill.circle"
                          : "circle")
                      .imageScale(.large)
                      .foregroundColor(.accentColor)
                    Text(todoItem.title)
                  }
            }
        }
        .navigationTitle("\(todoList.name)")
    }
}

#Preview {
    let personalList = TodoList.mockTodoLists[1]
    return ListView(todoList: personalList)
}
