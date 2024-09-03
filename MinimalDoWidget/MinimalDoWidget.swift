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
                Text(entry.widgetList.list.name)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.accentColor)
                Spacer()
                Text("\(entry.widgetList.list.todoItems.count)")
                    .font(.title3)
                    .bold()
            }
            ForEach(Array(entry.widgetList.list.todoItems
                .filter({ !$0.isDone }).prefix(3).enumerated()),
                    id: \.offset) { index, item in
                HStack {
                    Button(intent: ToggleItemIntent(todoIndex: index, listIndex: entry.widgetList.index)) {
                        Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Text(item.title)
                        .font(.footnote)
                        .foregroundColor(item.isDone ? .gray : .black)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .padding(.top, 1)
            }
        }
    }

    var mediumWidgetView: some View {
        GeometryReader { geometry in
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Spacer()
                    Text("\(entry.widgetList.list.todoItems.count)")
                        .font(.title3)
                        .bold()
                    Text(entry.widgetList.list.name)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.accentColor)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(width: geometry.size.width / 4)

                VStack(alignment: .leading) {
                    ForEach(Array(entry.widgetList.list.todoItems
                        .filter({ !$0.isDone }).prefix(4).enumerated()),
                            id: \.offset) { index, item in
                        HStack {
                            Button(intent: ToggleItemIntent(todoIndex: index, listIndex: entry.widgetList.index)) {
                                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.gray)
                            }
                            .buttonStyle(PlainButtonStyle())

                            Text(item.title)
                                .font(.footnote)
                                .foregroundColor(item.isDone ? .gray : .black)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.top, 2)
                    }
                    if entry.widgetList.list.todoItems.filter({ !$0.isDone }).isEmpty {
                        Text("All tasks completed")
                            .font(.subheadline)
                    }
                }
                .frame(width: geometry.size.width * 3 / 4)
            }
        }
        .padding(.horizontal, 10)
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
    ListEntry(date: .now, widgetList: WidgetList(id: "1", index: 0, list: TodoList(name: "Personal Tasks", todoItems: [
        TodoItem(title: "Buy groceries", isDone: false),
        TodoItem(title: "Finish project report", isDone: true),
        TodoItem(title: "Call Mom", isDone: false),
        TodoItem(title: "Walk the dog", isDone: false),
        TodoItem(title: "Read a book", isDone: true),
        TodoItem(title: "Workout", isDone: false),
        TodoItem(title: "Clean the house", isDone: true)
    ])))
    ListEntry(date: .now.addingTimeInterval(3600),
              widgetList: WidgetList(id: "2", index: 1, list: TodoList(name: "Work Tasks", todoItems: [
        TodoItem(title: "Email client", isDone: false),
        TodoItem(title: "Team meeting", isDone: true),
        TodoItem(title: "Prepare presentation", isDone: false),
        TodoItem(title: "Review budget", isDone: false),
        TodoItem(title: "Write code documentation", isDone: true)
    ])))
}

#Preview(as: .systemSmall) {
    MinimalDoWidget()
} timeline: {
    ListEntry(date: .now, widgetList: WidgetList(id: "3", index: 0, list: TodoList(name: "Quick Tasks", todoItems: [
        TodoItem(title: "Water plants", isDone: false),
        TodoItem(title: "Reply to texts", isDone: true),
        TodoItem(title: "Take out trash", isDone: false),
        TodoItem(title: "Prepare lunch", isDone: false),
        TodoItem(title: "Check emails", isDone: false),
        TodoItem(title: "Set alarm", isDone: true)
    ])))
}
