import Foundation

public protocol StorageService {
    func saveItems<T: Codable>(_ items: [T])
    func loadItems<T: Codable>() -> [T]
}
