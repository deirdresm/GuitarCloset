//
//  Item+Extension.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/29/21.
//

import Foundation
import CoreData
import SwiftUI

extension Item {
	enum SortOrder {
		case optimized, title, createdOn
	}

	var itemTitle: String {
		title ?? NSLocalizedString("New Item", comment: "Create a new item")
	}

	var projectTitle: String {
		project?.projectTitle ?? ""
	}

	static var example: Item {
		let controller = Persistence.preview
		let viewContext = controller.container.viewContext

		let item = Item(context: viewContext)
		item.title = "Example Item"
		item.detail = "This is an example item"
		item.priority = 3
		item.createdOn = Date()
		return item
	}
}
