import AppIntents
import SwiftUI
import KovaleeSDK
import KovaleeFramework

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
        NotificationCenter.default.post(name: Notification.Name("TodoItemToggled"), object: nil)
        Kovalee.sendEvent(event: .acTodoItemCompleted("widget"))
        return .result()
    }
}
