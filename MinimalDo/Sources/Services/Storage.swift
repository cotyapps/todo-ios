import Foundation

protocol StorageService {
    func saveItems(_ items: [TodoList])
    func loadItems() -> [TodoList]
}

struct JSONStorageService: StorageService {
    private let containerURL: URL

    init() {
        let appGroupIdentifier = "group.com.kovalee.MinimalDo"
        guard let url = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupIdentifier
        ) else {
            fatalError("Failed to get shared container URL")
        }
        self.containerURL = url.appendingPathComponent("TodoLists.json")
    }

    func saveItems(_ items: [TodoList]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: containerURL)
        } catch {
            print("Cannot save data to JSON file: \(error)")
        }
    }

    func loadItems() -> [TodoList] {
        do {
            let data = try Data(contentsOf: containerURL)
            let decoder = JSONDecoder()
            return try decoder.decode([TodoList].self, from: data)
        } catch {
            print("Cannot load data from JSON file: \(error)")
            return []
        }
    }
}
