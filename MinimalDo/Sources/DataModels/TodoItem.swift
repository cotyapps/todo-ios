import Foundation

struct TodoItem: Codable, Identifiable {
    let id: UUID
    var title: String
    var isDone: Bool
    var description: String?
    var dueDate: Date?

    init(id: UUID = UUID(), title: String, isDone: Bool = false, description: String? = nil, dueDate: Date? = nil) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.description = description
        self.dueDate = dueDate
    }
}
