import Foundation

@Observable
class TodoManager {
    var lists: [TodoList] = []

    init(lists: [TodoList] = []) {
        self.lists = lists
    }

    func addList(_ list: TodoList) {
        lists.append(list)
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
