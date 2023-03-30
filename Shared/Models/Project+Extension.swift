//
//  Project+Extension.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/29/21.
//

import Foundation
import CoreData
import SwiftUI
import CloudKit

enum CloudStatus {
	case checking, exists, absent
}

extension Project {
	static let colors = ["Pink", "Purple", "Red", "Orange", "Gold",
		"Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]

	var projectTitle: String {
		title ?? NSLocalizedString("New Project", comment: "Create a new project")
	}

	var projectColor: String {
		color ?? "Light Blue"
	}

	var label: LocalizedStringKey {
		// swiftlint:disable:next line_length
		LocalizedStringKey("\(projectTitle), \(projectItems.count) items, \(completionAmount * 100, specifier: "%g")% complete.")
	}

	static var example: Project {
		let controller = Persistence.preview
		let viewContext = controller.container.viewContext

		let project = Project(context: viewContext)
		project.title = "Example Project"
		project.detail = "This is an example project"
		project.closed = true
		project.createdOn = Date()
		return project
	}

	var completionAmount: Double {
		let originalItems = items?.allObjects as? [Item] ?? []
		guard originalItems.isEmpty == false else { return 0 }

		let completedItems = originalItems.filter(\.completed)
		return Double(completedItems.count) / Double(originalItems.count)
	}

	var projectItems: [Item] {
		items?.allObjects as? [Item] ?? []
	}

	var projectItemsDefaultSorted: [Item] {
		projectItems.sorted { first, second in
			if first.completed == false {
				if second.completed == true {
					return true
				}
			} else if first.completed == true {
				if second.completed == false {
					return false
				}
			}

			if first.priority > second.priority {
				return true
			} else if first.priority < second.priority {
				return false
			}

			return first.createdOn.orNow < second.createdOn.orNow
		}
	}

	func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
		switch sortOrder {
		case .title:
			let sortDescriptor = NSSortDescriptor(keyPath: \Item.title, ascending: true)
			return self.projectItems.sorted(by: sortDescriptor)
		case .createdOn:
			let sortDescriptor = NSSortDescriptor(keyPath: \Item.createdOn, ascending: true)
			return self.projectItems.sorted(by: sortDescriptor)
		case .optimized:
			return projectItemsDefaultSorted
		}
	}

	func prepareCloudRecords(owner: String) -> [CKRecord] {
		let parentName = objectID.uriRepresentation().absoluteString
		let parentID = CKRecord.ID(recordName: parentName)
		let parent = CKRecord(recordType: "Project", recordID: parentID)
		parent["title"] = projectTitle
		parent["detail"] = detail.orEmpty
		parent["owner"] = owner
		parent["closed"] = closed

		var records = projectItemsDefaultSorted.map { item -> CKRecord in
			let childName = item.objectID.uriRepresentation().absoluteString
			let childID = CKRecord.ID(recordName: childName)
			let child = CKRecord(recordType: "Item", recordID: childID)
			child["title"] = item.itemTitle
			child["detail"] = item.detail.orEmpty
			child["completed"] = item.completed
			child["project"] = CKRecord.Reference(recordID: parentID, action: .deleteSelf)
			return child
		}

		records.append(parent)
		return records
	}

	// see if this one project is already in iCloud
	func checkCloudStatus(_ completion: @escaping (Bool) -> Void) {
		let name = objectID.uriRepresentation().absoluteString
		let id = CKRecord.ID(recordName: name)
		let operation = CKFetchRecordsOperation(recordIDs: [id])
		operation.desiredKeys = ["recordID"]

		operation.fetchRecordsCompletionBlock = { records, _ in
			if let records = records {
				completion(records.count == 1)
			} else {
				completion(false)
			}
		}

		CKContainer.default().publicCloudDatabase.add(operation)
	}
}
