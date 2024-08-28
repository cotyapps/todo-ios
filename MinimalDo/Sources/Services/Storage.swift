import Foundation

protocol StorageService {
    func saveItems(_ items: [TodoList])
    func loadItems() -> [TodoList]
}
