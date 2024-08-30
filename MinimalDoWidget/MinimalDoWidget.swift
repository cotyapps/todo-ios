import WidgetKit
import SwiftUI
import Foundation

struct Provider: TimelineProvider {
    let todoManager = TodoManager()

    func placeholder(in context: Context) -> SimpleEntry {
        let placeholderList = TodoList(name: "Placeholder List", todoItems: [
            TodoItem(title: "Sample Task 1", isDone: false),
            TodoItem(title: "Sample Task 2", isDone: true)
        ])
        return SimpleEntry(date: Date(), todoList: placeholderList)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        todoManager.loadList()
        let snapshotList = todoManager.lists.first ?? TodoList(name: "No Lists Available")
        let entry = SimpleEntry(date: Date(), todoList: snapshotList)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        todoManager.loadList()

        let currentDate = Date()
        let entryList = todoManager.lists.first ?? TodoList(name: "No Lists Available")

        let entry = SimpleEntry(date: currentDate, todoList: entryList)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let todoList: TodoList
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
                Text(entry.todoList.name)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.accentColor)
                Spacer()
                Text("\(entry.todoList.todoItems.count)")
                    .font(.title3)
                    .bold()
            }
            ForEach(entry.todoList.todoItems.filter({ !$0.isDone }).prefix(3)) { item in
                HStack {
                    Button(action: {
                        toggleItem(item, in: entry.todoList)
                    }) {
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
                    Text("\(entry.todoList.todoItems.count)")
                        .font(.title3)
                        .bold()
                    Text(entry.todoList.name)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.accentColor)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(width: geometry.size.width / 4)

                VStack(alignment: .leading) {
                    ForEach(entry.todoList.todoItems.filter({ !$0.isDone }).prefix(4)) { item in
                        HStack {
                            Button(action: {
                                toggleItem(item, in: entry.todoList)
                            }) {
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
                    if entry.todoList.todoItems.filter({ !$0.isDone }).isEmpty {
                        Text("All tasks completed")
                            .font(.subheadline)
                    }
                }
                .frame(width: geometry.size.width * 3 / 4)
            }
        }
        .padding(.horizontal, 10)
    }

    func toggleItem(_ item: TodoItem, in list: TodoList) {
        print("Done for \(item.title)")
    }
}

struct MinimalDoWidget: Widget {
    let kind: String = "MinimalDoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MinimalDoWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Todo Items")
        .description("This is a Todo List.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    MinimalDoWidget()
} timeline: {
    SimpleEntry(date: .now, todoList: TodoList(name: "Personal Tasks with a lot of task", todoItems: [
        TodoItem(title: "Buy groceries", isDone: false),
        TodoItem(title: "Finish project report", isDone: true),
        TodoItem(title: "Call Mom", isDone: false),
        TodoItem(title: "Walk the dog", isDone: false),
        TodoItem(title: "Read a book", isDone: true),
        TodoItem(title: "Workout", isDone: false),
        TodoItem(title: "Clean the house", isDone: true)
    ]))
    SimpleEntry(date: .now.addingTimeInterval(3600), todoList: TodoList(name: "Work Tasks", todoItems: [
        TodoItem(title: "Email client", isDone: false),
        TodoItem(title: "Team meeting", isDone: true),
        TodoItem(title: "Prepare presentation", isDone: false),
        TodoItem(title: "Review budget", isDone: false),
        TodoItem(title: "Write code documentation", isDone: true)
    ]))
}
#Preview(as: .systemSmall) {
    MinimalDoWidget()
} timeline: {
    SimpleEntry(date: .now, todoList: TodoList(name: "Quick Tasks", todoItems: [
        TodoItem(title: "Water plants with a lot of water", isDone: false),
        TodoItem(title: "Reply to texts", isDone: true),
        TodoItem(title: "Take out trash", isDone: false),
        TodoItem(title: "Prepare presentation", isDone: false),
        TodoItem(title: "Review budget", isDone: false),
        TodoItem(title: "Write code documentation", isDone: true)
    ]))
}
