import SwiftUI

struct AddEditItemView: View {
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var hasDueDate: Bool = false
    @State private var dueDate: Date = Date.now

    @Binding var todoList: TodoList
    var editingItem: TodoItem?

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
            .onAppear {
                guard let editingItem = editingItem else {
                    return
                }
                title = editingItem.title
                description = editingItem.description ?? ""
                hasDueDate = editingItem.dueDate != nil
                dueDate = editingItem.dueDate ?? Date.now
            }
            .navigationTitle(editingItem == nil ? "Add Todo" : "Edit Todo")
            .toolbar {
                Button("Save") {
                    if let editingItem = editingItem {
                        updateTodoItem(editingItem: editingItem)
                    } else {
                        addTodoItem()
                    }
                    dismiss()
                }
                .disabled(title.isEmpty)

                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }

    func addTodoItem() {
        guard !title.isEmpty else { return }
        let todoItem = TodoItem(
            title: title,
            description: description,
            dueDate: hasDueDate ? dueDate : nil
        )
        todoList.todoItems.append(todoItem)
    }

    func updateTodoItem(editingItem: TodoItem) {
        guard !title.isEmpty else { return }
        if let index = todoList.todoItems.firstIndex(where: { $0.id == editingItem.id }) {
            todoList.todoItems[index].title = title
            todoList.todoItems[index].description = description
            todoList.todoItems[index].dueDate = hasDueDate ? dueDate : nil
        }
    }

}
