import Foundation
import WidgetKit

@Observable
class TodoManager {
    var lists: [TodoList] = [] {
        didSet {
            saveList()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    private let storageService: StorageService

    init(storageService: StorageService = JSONStorageService()) {
        self.storageService = storageService
        loadList()
    }

    func loadList() {
        lists = storageService.loadItems()
    }

    func saveList() {
        storageService.saveItems(lists)
    }

    func addList(_ list: TodoList) {
        lists.append(list)
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
