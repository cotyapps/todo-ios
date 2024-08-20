import Foundation

struct TodoList: Identifiable, Codable {
    let id: UUID
    var name: String
    var todoItems: [TodoItem]

    init(id: UUID = UUID(), name: String, todoItems: [TodoItem] = []) {
        self.id = id
        self.name = name
        self.todoItems = todoItems
    }
}

extension TodoList {
    static let mockLists = [
        TodoList(name: "Work", todoItems: [
            TodoItem(title: "Finish project report", isDone: false, listId: UUID(),
                     dueDate: Date().addingTimeInterval(172800)),
            TodoItem(title: "Prepare presentation", isDone: false, listId: UUID(),
                     description: nil, dueDate: Date().addingTimeInterval(345600))
        ]),
        TodoList(name: "Personal", todoItems: [
            TodoItem(title: "Buy groceries", isDone: false, listId: UUID(),
                     description: "Don't forget milk", dueDate: Date().addingTimeInterval(86400)),
            TodoItem(title: "Call mom", isDone: true, listId: UUID(),
                     description: nil, dueDate: nil),
            TodoItem(title: "Go for a run", isDone: false, listId: UUID(),
                     description: "30 minutes", dueDate: Date())
        ]),
        TodoList(name: "Learning", todoItems: [
            TodoItem(title: "Read a chapter", isDone: false, listId: UUID(),
                     description: "From 'The Pragmatic Programmer'", dueDate: nil),
            TodoItem(title: "Complete online course module", isDone: false, listId: UUID(),
                     description: "SwiftUI Fundamentals", dueDate: Date().addingTimeInterval(518400))
        ])
    ]
}
