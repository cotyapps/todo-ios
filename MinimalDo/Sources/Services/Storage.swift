import Foundation

protocol StorageService {
    func saveItems(_ items: [TodoList])
    func loadItems() -> [String: TodoList]
}

public class JSONStorageService: StorageService {
    private let fileName: String

    init(fileName: String) {
        self.fileName = fileName
    }

    private func getFilePath() -> URL? {
        guard let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
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
                if !FileManager.default.fileExists(atPath: fileURL.path) {
                    FileManager.default.createFile(atPath: fileURL.path, contents: data, attributes: nil)
                } else {
                    try data.write(to: fileURL)
                }
            }
        } catch {
            print("Cannot save data to JSON file")
        }
    }

    func loadItems() -> [String: TodoList] {
        guard let fileURL = getFilePath() else {
            return [:]
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let todoListsDict = try decoder.decode([String: TodoList].self, from: data)
            return todoListsDict
        } catch {
            print("Cannot load data from JSON file: \(error)")
            return [:]
        }
    }
}
