//
//  ItemRowView.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 9/10/22.
//

import SwiftUI

struct ItemRowView: View {
	@State var selectedItem: Item?

	@ObservedObject var project: Project
	@ObservedObject var item: Item

	func icon() -> some View {
		if item.completed {
			return Image(systemName: "checkmark.circle")
				.foregroundColor(Color(project.projectColor))
		} else if item.priority == 3 {
			return Image(systemName: "exclamationmark.triangle.fill")
				.foregroundColor(Color(project.projectColor))
		} else if item.priority == 2 {
			return Image(systemName: "exclamationmark.triangle")
				.foregroundColor(Color(project.projectColor))
		} else {
			return Image(systemName: "checkmark.circle")
				.foregroundColor(.clear)
		}
	}

	var label: Text {
		if item.completed {
			return Text("\(item.itemTitle), completed.")
		} else if item.priority == 3 {
			return Text("\(item.itemTitle), high priority.")
		} else {
			return Text(item.itemTitle)
		}
	}

	var body: some View {
		NavigationLink(destination: EditItemView(item: item)) {
			Label(title: {
				Text(item.itemTitle)
			}, icon: icon)
			.accessibilityLabel(label)
		}
	}
}

//struct ItemRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRowView()
//    }
//}
