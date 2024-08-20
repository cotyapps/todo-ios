import SwiftUI

struct ListView: View {
    @State var todoList: TodoList

    var body: some View {
        List {
            ForEach($todoList.todoItems) { $todoItem in
                HStack {
                    Image(systemName: todoItem.isDone
                          ? "largecircle.fill.circle"
                          : "circle")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        todoItem.isDone.toggle()
                    }
                    VStack(alignment: .leading) {
                        Text(todoItem.title)
                            .font(.headline)
                        if let description = todoItem.description, !description.isEmpty {
                            Text(description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        if let dueDate = todoItem.dueDate {
                            HStack {
                                Image(systemName: "calendar")
                                    .imageScale(.small)
                                    .foregroundColor(.secondary)
                                Text(dueDate, style: .date)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 2)
                        }
                    }
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
