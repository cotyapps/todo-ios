import SwiftUI

struct ElementView: View {
    @Binding var todoItem: TodoItem

    var body: some View {
        Button(action: {
            todoItem.isDone.toggle()
        }) {
            HStack {
                Image(systemName: todoItem.isDone ? "largecircle.fill.circle" : "circle")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                VStack(alignment: .leading) {
                    Text(todoItem.title)
                        .font(.headline)
                        .foregroundColor(.black)
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
}
