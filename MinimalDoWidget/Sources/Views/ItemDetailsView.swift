import SwiftUI
import AppIntents

struct UndoneItemsView: View {
    let widgetList: WidgetList
    let itemLimit: Int

    var body: some View {
        ForEach(Array(widgetList.list.todoItems
            .filter({ !$0.isDone }).prefix(itemLimit).enumerated()),
                id: \.offset) { index, item in
            ItemButtonView(item: item,
                           intent: ToggleItemIntent(todoIndex: index, listIndex: widgetList.index))
            .padding(.top, 2)
        }
        if widgetList.list.todoItems.filter({ !$0.isDone }).isEmpty {
            Text("All tasks completed")
                .font(.subheadline)
        }
    }
}

struct ItemButtonView: View {
    let item: TodoItem
    let intent: any AppIntent

    var body: some View {
        Button(intent: intent) {
            HStack {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.gray)
                Text(item.title)
                    .font(.footnote)
                    .foregroundColor(item.isDone ? .gray : .black)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
