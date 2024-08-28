import Foundation

protocol StorageService {
    func saveItems(_ items: [TodoList])
    func loadItems() -> [TodoList]
}

public struct JSONStorageService: StorageService {
    private let fileName: String
    private let fileManager = FileManager.default

    init(fileName: String) {
        self.fileName = fileName
    }

    private func getFilePath() -> URL? {
        guard let filePath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return filePath.appendingPathComponent(fileName)
    }

    func saveItems(_ items: [TodoList]) {
        let encoder = JSONEncoder()
        let itemsDictionary = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
        do {
            let data = try encoder.encode(itemsDictionary)
            if let fileURL = getFilePath() {
                if !fileManager.fileExists(atPath: fileURL.path) {
                    fileManager.createFile(atPath: fileURL.path, contents: data, attributes: nil)
                } else {
                    try data.write(to: fileURL)
                }
            }
        } catch {
            print("Cannot save data to JSON file")
        }
    }

    func loadItems() -> [TodoList] {
        guard let fileURL = getFilePath() else {
            return []
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let todoListsDict = try decoder.decode([String: TodoList].self, from: data)
            return Array(todoListsDict.values)
        } catch {
            print("Cannot load data from JSON file: \(error)")
            return []
        }
    }
}
