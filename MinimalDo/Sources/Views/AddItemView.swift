import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var description = ""
    @State private var hasDueDate = false
    @State private var dueDate = Date.now

    @Binding var todoList: TodoList

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)

                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                }

                Toggle("Due on", isOn: $hasDueDate)

                if hasDueDate {
                    DatePicker(selection: $dueDate, in: ...Date.now, displayedComponents: .date) {
                        Text("")
                    }
                }
            }
            .navigationTitle("Add Todo")
            .toolbar {
                Button("Save") {
                    guard !title.isEmpty else { return }
                    let todoItem = TodoItem(
                        title: title,
                        description: description.isEmpty ? nil : description,
                        dueDate: hasDueDate ? dueDate : nil
                    )
                    todoList.todoItems.append(todoItem)
                    dismiss()
                }
                .disabled(title.isEmpty)

                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    @State var previewTodoList = TodoList(name: "Personal", todoItems: [])
    return AddItemView(todoList: $previewTodoList)
}
