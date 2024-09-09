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
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "isFirstLaunch"

    init(storageService: StorageService = JSONStorageService()) {
        self.storageService = storageService
        if isFirstLaunch() {
            lists = TodoList.mockTodoLists
            saveList()
            setFirstLaunchComplete()
        } else {
            loadList()
        }
    }

    private func isFirstLaunch() -> Bool {
        return !userDefaults.bool(forKey: firstLaunchKey)
    }

    private func setFirstLaunchComplete() {
        userDefaults.set(true, forKey: firstLaunchKey)
    }

    func loadList() {
        self.lists = storageService.loadItems()
    }

    func saveList() {
        storageService.saveItems(self.lists)
    }

    func canAddList() async -> Bool {
        do {
            let isSubscribed = try await checkIfSubscribe()
            return countLists() < 3 || isSubscribed
        } catch {
            print("Error checking subscription: \(error)")
            return false
        }
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

    func getWidgetLists() -> [WidgetList] {
        return Array(lists.enumerated()).map { index, todoList in
            WidgetList(id: String(index), index: index, list: todoList)
        }
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

    func toggleTodo(todoIndex: Int, listIndex: Int) {
        guard listIndex >= 0 && listIndex < lists.count else {
            print("Invalid list index")
            return
        }

        let allTodoItems = lists[listIndex].todoItems
        let undoneTodoItems = allTodoItems.filter { !$0.isDone }

        guard todoIndex >= 0 && todoIndex < undoneTodoItems.count else {
            print("Invalid todo index")
            return
        }

        if let fullListIndex = allTodoItems.firstIndex(where: { $0.id == undoneTodoItems[todoIndex].id }) {
            lists[listIndex].todoItems[fullListIndex].isDone.toggle()
            saveList()
        } else {
            print("Couldn't find the todo item in the full list")
        }
    }
}
