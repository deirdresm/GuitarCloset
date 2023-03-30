//
//  ProjectsVM.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 1/11/22.
//

import CoreData
import Foundation
import SwiftUI

extension ProjectsView {
	public enum SortOrder {
		case optimized, title, createdOn
	}

	class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {

		let persistence: Persistence

		var showingSortOrder = false
		var sortOrder: SortOrder = .optimized
		var showClosedProjects: Bool

		private let projectsController: NSFetchedResultsController<Project>
		@Published var projects = [Project]()
		@Published var selectedItem: Item?

		@Published var showingUnlockView = false

		@State var sortDescriptor: NSSortDescriptor?

		init(persistence: Persistence, showClosedProjects: Bool) {
			self.persistence = persistence
			self.showClosedProjects = showClosedProjects

			let request: NSFetchRequest<Project> = Project.fetchRequest()
			request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.createdOn, ascending: false)]
			request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)

			projectsController = NSFetchedResultsController(
				fetchRequest: request,
				managedObjectContext: persistence.container.viewContext,
				sectionNameKeyPath: nil,
				cacheName: nil
			)
			super.init()
			projectsController.delegate = self

			do {
				try projectsController.performFetch()
				projects = projectsController.fetchedObjects ?? []
			} catch {
				print("Failed to fetch projects")
			}
		}

		/// addProject - calls persistence's method of the same name
		func addProject() {
			if persistence.addProject() == false {
				showingUnlockView.toggle()
			}
		}

		func addItem(to project: Project) {
			let item = Item(context: persistence.container.viewContext)
			item.project = project
			item.createdOn = Date()
			item.priority = 2
			item.completed = false
			persistence.save()
		}

		func items(for project: Project) -> [Item] {
			guard let sortDescriptor = sortDescriptor else {
				return project.projectItemsDefaultSorted
			}
			return project.projectItems.sorted(by: sortDescriptor)
		}

		func delete(_ offsets: IndexSet, from project: Project) {
			let allItems = items(for: project)

			for offset in offsets {
				let item = allItems[offset]
				persistence.delete(item)
			}

			persistence.save()
		}

		func delete(_ item: Item) {
			persistence.delete(item)
			persistence.save()
		}

#if DEBUG
		func deleteAll() {
			persistence.deleteAll()
		}
#endif

		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			if let newProjects = controller.fetchedObjects as? [Project] {
				projects = newProjects
			}
		}
	}
}
