import Foundation

class TodoManager: ObservableObject {
    @Published var lists: [TodoList] = []
    
    func addList(_ list: TodoList) {
        lists.append(list)
    }
    
    func removeList(at index: IndexSet) {
        lists.remove(atOffsets: index)
    }
    
    func addTodo(_ todo: TodoItem, to listId: UUID) {
        if let index = lists.firstIndex(where: { $0.id == listId }) {
            lists[index].todoItems.append(todo)
        }
    }
    
    func removeTodo(_ todo: TodoItem, from listId: UUID) {
        if let listIndex = lists.firstIndex(where: { $0.id == listId }),
           let todoIndex = lists[listIndex].todoItems.firstIndex(where: { $0.id == todo.id }) {
            lists[listIndex].todoItems.remove(at: todoIndex)
        }
    }
}
