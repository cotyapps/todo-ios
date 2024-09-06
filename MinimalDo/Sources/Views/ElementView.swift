import SwiftUI
import KovaleeSDK
import KovaleeFramework

struct ElementView: View {
    @Binding var todoItem: TodoItem
    @State private var isCompleting = false

    var body: some View {
        HStack {
            Button(action: {
                Task { await completeTodoItem() }
            }, label: {
                Image(systemName: isCompleting ? "largecircle.fill.circle" : "circle")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            })
            VStack(alignment: .leading) {
                Text(todoItem.title)
                    .font(.headline)
                    .foregroundColor(isCompleting ? .gray : .black)
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
                        Text(dueDate, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 2)
                }
            }
        }
        .opacity(isCompleting ? 0.5 : 1.0)
    }

    private func completeTodoItem() async {
        withAnimation(.easeInOut(duration: 0.2)) {
            isCompleting = true
        }

        try? await Task.sleep(for: .seconds(1.0))

        withAnimation(.easeInOut(duration: 0.2)) {
            todoItem.isDone.toggle()
        }
        Kovalee.sendEvent(event: .acTodoItemCompleted("app"))
    }
}
