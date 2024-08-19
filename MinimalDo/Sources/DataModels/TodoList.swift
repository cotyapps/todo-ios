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
