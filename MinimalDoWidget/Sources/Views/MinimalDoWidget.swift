import WidgetKit
import SwiftUI
import Foundation

struct Provider: AppIntentTimelineProvider {
    let todoManager = TodoManager()

    func timeline(for configuration: SelectListIntent, in context: Context) async -> Timeline<ListEntry> {
        todoManager.loadList()
        let list = configuration.list ?? todoManager.getWidgetLists().first ?? WidgetList(
            id: "No lists available",
            index: -1,
            list: TodoList(name: "No lists available")
        )
        return Timeline(
            entries: [ListEntry(date: .now, widgetList: list)],
            policy: .atEnd
        )
    }

    func snapshot(for configuration: SelectListIntent, in context: Context) async -> ListEntry {
        todoManager.loadList()
        let list = configuration.list ?? todoManager.getWidgetLists().first ?? WidgetList(
            id: "No lists available",
            index: -1,
            list: TodoList(name: "No lists available")
        )
        return ListEntry(date: .now, widgetList: list)
    }

    func placeholder(in context: Context) -> ListEntry {
        return ListEntry(
            date: .now,
            widgetList: WidgetList(id: "Placeholder id",
                                   index: -1,
                                   list: TodoList(name: "Place holder list"))
        )
    }
}

struct ListEntry: TimelineEntry {
    let date: Date
    let widgetList: WidgetList
}

struct MinimalDoWidgetEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            smallWidgetView
        case .systemMedium:
            mediumWidgetView
        default:
            mediumWidgetView
        }
    }

    var smallWidgetView: some View {
        VStack(alignment: .leading) {
            HStack {
                ListTitleView(listName: entry.widgetList.list.name, lineLimit: 1)
                Spacer()
                UndoneItemCountView(todoItems: entry.widgetList.list.todoItems)
            }
            UndoneItemsView(widgetList: entry.widgetList, itemLimit: 3)
                .padding(.top, 1)
        }
        .containerBackground(for: .widget) {
            Color.white
        }

    }

    var mediumWidgetView: some View {
        GeometryReader { geometry in
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Spacer()
                    UndoneItemCountView(todoItems: entry.widgetList.list.todoItems)
                    ListTitleView(listName: entry.widgetList.list.name, lineLimit: 2)
                }
                .frame(width: geometry.size.width / 4)

                VStack(alignment: .leading) {
                    UndoneItemsView(widgetList: entry.widgetList, itemLimit: 4)
                }
                .frame(width: geometry.size.width * 3 / 4)
            }
        }
        .padding(.horizontal, 10)
        .containerBackground(for: .widget) {
            Color.white
        }
    }
}

struct MinimalDoWidget: Widget {
    let kind: String = "MinimalDoWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectListIntent.self,
            provider: Provider()
        ) { entry in
            MinimalDoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Todo List Widget")
        .description("Displays a todo list")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    MinimalDoWidget()
} timeline: {
    let workList = TodoList.mockTodoLists[0]
    ListEntry(date: .now, widgetList: WidgetList(id: workList.id.uuidString, index: 0, list: workList))

    let personalList = TodoList.mockTodoLists[1]
    ListEntry(date: .now.addingTimeInterval(3600),
              widgetList: WidgetList(id: personalList.id.uuidString, index: 1, list: personalList))
}

#Preview(as: .systemSmall) {
    MinimalDoWidget()
} timeline: {
    let learningList = TodoList.mockTodoLists[2]
    ListEntry(date: .now, widgetList: WidgetList(id: learningList.id.uuidString, index: 2, list: learningList))
}
