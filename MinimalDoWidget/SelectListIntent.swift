import AppIntents
import SwiftUI

struct WidgetList: AppEntity {
    var id: String
    var index: Int
    var list: TodoList

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Widget List"
    static var defaultQuery = WidgetListQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(list.name)")
    }
}

struct WidgetListQuery: EntityQuery {
    func entities(for identifiers: [WidgetList.ID]) async throws -> [WidgetList] {
        let todoManager = TodoManager()
        print("func entities(for identifiers: [WidgetList.ID]) async throws ->")
        return todoManager.getWidgetLists().filter {
            identifiers.contains($0.id)
        }
    }

    func suggestedEntities() async throws -> [WidgetList] {
        let todoManager = TodoManager()
        print("func suggestedEntities() async throws -> [WidgetList] {")
        return todoManager.getWidgetLists()
    }

    func defaultResult() async -> WidgetList? {
        let todoManager = TodoManager()
        print("func defaultResult() async -> WidgetList? {")
        return todoManager.getWidgetLists().first
    }
}

struct SelectListIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Todo List"
    static var description: IntentDescription = IntentDescription("Select Your Todo List")

    @Parameter(title: "Chosen Todo List")
    var list: WidgetList?

    init() {
        self.list = nil
    }

    init(list: WidgetList?) {
        self.list = list
    }

    static var defaultValue: SelectListIntent {
        let todoManager = TodoManager()
        let defaultList = todoManager.getWidgetLists().first
        return SelectListIntent(list: defaultList)
    }
}
