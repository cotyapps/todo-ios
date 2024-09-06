import SwiftUI
import UserNotifications
import KovaleeSDK
import KovaleeFramework

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
                    DatePicker(
                        "Due Date",
                        selection: $dueDate,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
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
                    Task {
                        if let editingItem = editingItem {
                            updateTodoItem(editingItem: editingItem)
                        } else {
                            await addTodoItem()
                            Kovalee.sendEvent(event: .acTodoItemCreated)
                        }
                        dismiss()
                    }
                }
                .disabled(title.isEmpty)

                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }

    func addTodoItem() async {
        guard !title.isEmpty else { return }
        let todoItem = TodoItem(
            title: title,
            description: description,
            dueDate: hasDueDate ? dueDate : nil
        )
        todoList.todoItems.append(todoItem)

        if hasDueDate {
            let notiAllowed = await isNotificationAllowed()
            if !notiAllowed {
                do {
                    let success = try await UNUserNotificationCenter.current()
                        .requestAuthorization(options: [.alert, .badge, .sound])
                    if success {
                        scheduleNotification(for: todoItem)
                    }
                } catch {
                    print("Notification permission error: \(error.localizedDescription)")
                }
            } else {
                scheduleNotification(for: todoItem)
            }
        }
    }

    func updateTodoItem(editingItem: TodoItem) {
        guard !title.isEmpty else { return }
        if let index = todoList.todoItems.firstIndex(where: { $0.id == editingItem.id }) {
            todoList.todoItems[index].title = title
            todoList.todoItems[index].description = description
            todoList.todoItems[index].dueDate = hasDueDate ? dueDate : nil
        }
    }

    func scheduleNotification(for item: TodoItem) {
        let content = UNMutableNotificationContent()
        content.title = item.title
        content.body = item.description ?? ""
        content.sound = .default

        if let dueDate = item.dueDate {
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                                              from: dueDate)

            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

            let request = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
}
