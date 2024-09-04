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
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(items)
            try data.write(to: containerURL, options: .atomic)
            print("Successfully saved data to \(containerURL.path)")
        } catch {
            print("Error saving data to JSON file: \(error)")
        }
    }

    func loadItems() -> [TodoList] {
        do {
            if !FileManager.default.fileExists(atPath: containerURL.path) {
                print("File does not exist at \(containerURL.path). Returning empty array.")
                return []
            }

            let data = try Data(contentsOf: containerURL)

            guard !data.isEmpty else {
                print("File is empty at \(containerURL.path). Returning empty array.")
                return []
            }

            let decoder = JSONDecoder()
            let items = try decoder.decode([TodoList].self, from: data)
            print("Successfully loaded \(items.count) items from \(containerURL.path)")
            return items
        } catch {
            print("Error loading data from JSON file: \(error)")
            return []
        }
    }
}
