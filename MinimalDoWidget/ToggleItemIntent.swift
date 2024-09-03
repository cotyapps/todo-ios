import AppIntents
import SwiftUI

struct ToggleItemIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Task"
    static var description = IntentDescription("Toggles the completion status of a task.")

    @Parameter(title: "Task Index")
    var todoIndex: Int

    @Parameter(title: "List Index")
    var listIndex: Int

    init() {}

    init(todoIndex: Int, listIndex: Int) {
        self.todoIndex = todoIndex
        self.listIndex = listIndex
    }

    func perform() async throws -> some IntentResult {
        let todoManager = TodoManager()
        todoManager.toggleTodo(todoIndex: todoIndex, listIndex: listIndex)
        return .result()
    }
}
