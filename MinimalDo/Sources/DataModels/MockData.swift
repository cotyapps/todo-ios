import Foundation

extension TodoItem {
    static let mockTodoItems = [
        TodoItem(title: "Update resume", isDone: false,
                 description: "Add recent project experience", dueDate: Date().addingTimeInterval(604800)),
        TodoItem(title: "Meditate", isDone: false,
                 description: "15 minutes of mindfulness", dueDate: Date())
    ]
}

extension TodoList {
    static let mockTodoLists: [TodoList] = {
        let workList = TodoList(name: "Work")
        let personalList = TodoList(name: "Personal")
        let learningList = TodoList(name: "Learning")
        let travelList = TodoList(name: "Travel")

        return [
            TodoList(id: workList.id, name: workList.name, todoItems: [
                TodoItem(title: "Finish project report", isDone: false,
                         description: "Include Q2 metrics", dueDate: Date().addingTimeInterval(172800)),
                TodoItem(title: "Prepare presentation", isDone: false,
                         description: "Sales pitch for new client", dueDate: Date().addingTimeInterval(345600)),
            ]),
            TodoList(id: personalList.id, name: personalList.name, todoItems: [
                TodoItem(title: "Buy groceries", isDone: false,
                         description: "Don't forget milk and eggs", dueDate: Date().addingTimeInterval(86400)),
                TodoItem(title: "Call mom", isDone: true,
                         description: "Ask about family trip", dueDate: nil),
                TodoItem(title: "Go for a run", isDone: false,
                         description: "30 minutes in the gym", dueDate: Date()),
            ]),
            TodoList(id: learningList.id, name: learningList.name, todoItems: [
                TodoItem(title: "Read a chapter", isDone: false,
                         description: "From 'The Pragmatic Programmer'", dueDate: nil),
                TodoItem(title: "Complete online course module", isDone: false,
                         description: "SwiftUI Fundamentals", dueDate: Date().addingTimeInterval(518400))
            ]),
            TodoList(id: travelList.id, name: travelList.name, todoItems: [
                TodoItem(title: "Plan weekend trip", isDone: false,
                         description: "Check hotel prices and activities", dueDate: Date().addingTimeInterval(259200))
            ])
        ]
    }()
}
