import SwiftUI

struct ListTitleView: View {
    let listName: String
    let lineLimit: Int

    var body: some View {
        Text(listName)
            .font(.subheadline)
            .bold()
            .foregroundColor(.accentColor)
            .lineLimit(lineLimit)
            .truncationMode(.tail)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct UndoneItemCountView: View {
    let todoItems: [TodoItem]

    var body: some View {
        Text("\(todoItems.filter { !$0.isDone }.count)")
            .font(.title3)
            .bold()
    }
}
