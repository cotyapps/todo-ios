import Foundation

extension TodoItem {
    static let mockTodoItems = [
        TodoItem(title: "Update resume", isDone: false, listId: UUID(),
                 description: "Add recent project experience", dueDate: Date().addingTimeInterval(604800)),
        TodoItem(title: "Meditate", isDone: false, listId: UUID(),
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
                TodoItem(title: "Finish project report", isDone: false, listId: workList.id,
                         description: "Include Q2 metrics", dueDate: Date().addingTimeInterval(172800)),
                TodoItem(title: "Prepare presentation", isDone: false, listId: workList.id,
                         description: "Sales pitch for new client", dueDate: Date().addingTimeInterval(345600)),
            ]),
            TodoList(id: personalList.id, name: personalList.name, todoItems: [
                TodoItem(title: "Buy groceries", isDone: false, listId: personalList.id,
                         description: "Don't forget milk and eggs", dueDate: Date().addingTimeInterval(86400)),
                TodoItem(title: "Call mom", isDone: true, listId: personalList.id,
                         description: "Ask about family trip", dueDate: nil),
                TodoItem(title: "Go for a run", isDone: false, listId: personalList.id,
                         description: "30 minutes in the gym", dueDate: Date()),
            ]),
            TodoList(id: learningList.id, name: learningList.name, todoItems: [
                TodoItem(title: "Read a chapter", isDone: false, listId: learningList.id,
                         description: "From 'The Pragmatic Programmer'", dueDate: nil),
                TodoItem(title: "Complete online course module", isDone: false, listId: learningList.id,
                         description: "SwiftUI Fundamentals", dueDate: Date().addingTimeInterval(518400))
            ]),
            TodoList(id: travelList.id, name: travelList.name, todoItems: [
                TodoItem(title: "Plan weekend trip", isDone: false, listId: travelList.id,
                         description: "Check hotel prices and activities", dueDate: Date().addingTimeInterval(259200))
            ])
        ]
    }()
}

extension TodoManager {
    private static var _mockManager: TodoManager?

    static var mockManager: TodoManager {
        if let manager = _mockManager {
            return manager
        } else {
            let manager = TodoManager()
            manager.lists = TodoList.mockTodoLists
            _mockManager = manager
            return manager
        }
    }
}

func addMoreMockData() {
    let mockManager = TodoManager.mockManager

    print("--- Adding Mock Data ---\n")

    let moviesList = TodoList(name: "Movies")
    mockManager.addList(moviesList)

    let movieTodo = TodoItem(title: "Watch IronMan 3", isDone: false, listId: UUID())
    mockManager.addTodo(movieTodo, to: moviesList.id)
}

func removeMockList(listName: String) {
    let mockManager = TodoManager.mockManager

    print("--- Removing Mock Data ---")

    guard let index = mockManager.lists.firstIndex(where: { $0.name == listName}) else {
        print("List \(listName) not found\n")
        return
    }

    let indexSet = IndexSet(integer: index)
    mockManager.removeList(at: indexSet)
    print("List \(listName) removed successfully\n")
}

func printMockData() {
    let mockManager = TodoManager.mockManager

    print("--- Printing Mock Data ---")

    for (index, list) in mockManager.lists.enumerated() {
        print("List \(index + 1): \(list.name)")

        for (itemIndex, item) in list.todoItems.enumerated() {
            print("  Item \(itemIndex + 1):")
            print("    Title: \(item.title)")
            print("    Done: \(item.isDone)")
            print("    List Id: \(item.listId)")
        }
    }
    print("")
}
