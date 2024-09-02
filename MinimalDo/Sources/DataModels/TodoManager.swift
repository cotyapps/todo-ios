import Foundation

@Observable
class TodoManager {
    var lists: [TodoList] = []

    private let storageService: StorageService

    init(lists: [TodoList] = [], storageService: StorageService = JSONStorageService(fileName: "TodoLists.json")) {
        self.lists = lists
        self.storageService = storageService
    }

    func loadList() {
        let loadedItems = storageService.loadItems()
        self.lists = loadedItems
    }
    
    func checkAddList() -> Bool {
        return countLists() < 1 || checkIfSubscribe()
    }

    func addList(_ list: TodoList) {
        lists.append(list)
    }

    func countLists() -> Int {
        return lists.count
    }

    func changeListName(at index: IndexSet, newName: String) {
        guard let index = index.first else { return }
        lists[index].name = newName
    }

    func removeList(at index: IndexSet) {
        lists.remove(atOffsets: index)
    }

    func addTodo(_ todo: TodoItem, to listId: UUID) {
        guard let index = lists.firstIndex(where: { $0.id == listId }) else {
            return
        }
        lists[index].todoItems.append(todo)
    }

    func removeTodo(_ todo: TodoItem, from listId: UUID) {
        guard
            let listIndex = lists.firstIndex(where: { $0.id == listId }),
            let todoIndex = lists[listIndex].todoItems.firstIndex(where: { $0.id == todo.id })
        else {
            return
        }
        lists[listIndex].todoItems.remove(at: todoIndex)
    }
}
