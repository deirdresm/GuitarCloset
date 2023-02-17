//
//  PedalsVM.swift
//  GuitarCloset
//
//  Created by Deirdre Saoirse Moen on 1/28/23.
//

import CoreData
import Foundation
import SwiftUI

extension PedalsView {
	class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
		let persistence: Persistence

		var showingSortOrder = false

		private let guitarsController: NSFetchedResultsController<Guitar>
		@Published var guitars = [Guitar]()

		@State var sortDescriptor: NSSortDescriptor?

		init(persistence: Persistence) {
			self.persistence = persistence

			let request: NSFetchRequest<Guitar> = Guitar.fetchRequest()
			request.sortDescriptors = [NSSortDescriptor(keyPath: \Guitar.purchasedOn, ascending: false)]
//			request.predicate = NSPredicate(format: "closed = %d", showClosedGuitars)

			guitarsController = NSFetchedResultsController(
				fetchRequest: request,
				managedObjectContext: persistence.container.viewContext,
				sectionNameKeyPath: nil,
				cacheName: nil
			)
			super.init()
			guitarsController.delegate = self

			do {
				try guitarsController.performFetch()
				guitars = guitarsController.fetchedObjects ?? []
			} catch {
				print("Failed to fetch guitars")
			}
		}

		func addGuitar() {
			let guitar = Guitar(context: persistence.container.viewContext)

			guitar.purchasedOn = Date()
			persistence.save()
		}

		func setups(for guitar: Guitar) -> [Setup] {
			guard let sortDescriptor = sortDescriptor else {
				return guitar.guitarSetupsDefaultSorted
			}
			return guitar.guitarSetups.sorted(by: sortDescriptor)
		}

		func delete(_ offsets: IndexSet, from guitar: Guitar) {
			let allSetups = setups(for: guitar)

			for offset in offsets {
				let item = allSetups[offset]
				persistence.delete(item)
			}

			persistence.save()
		}

#if DEBUG
		func deleteAll() {
			persistence.deleteAll()
		}
#endif

		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			if let newGuitars = controller.fetchedObjects as? [Guitar] {
				guitars = newGuitars
			}
		}
	}
}
