//
//  HomeViewVM.swift
//  GuitarCloset
//
//  Created by Deirdre Saoirse Moen on 2/3/22.
//

import Foundation
import CoreData

extension HomeView {
	class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
		private let guitarsController: NSFetchedResultsController<Guitar>
		private let setupsController: NSFetchedResultsController<Setup>
		private let tuningsController: NSFetchedResultsController<Tuning>

		@Published var guitars = [Guitar]()
		@Published var tunings = [Tuning]()
		@Published var setups = [Setup]()

		var upNext: ArraySlice<Setup> {
			setups.prefix(3)
		}

		var moreToExplore: ArraySlice<Setup> {
			setups.dropFirst(3)
		}

		var persistence: Persistence

		init(persistence: Persistence) {
			self.persistence = persistence
			// Construct a fetch request to show all open guitars.
			let guitarRequest: NSFetchRequest<Guitar> = Guitar.fetchRequest()
//			guitarRequest.predicate = NSPredicate(format: "closed = false")
			guitarRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Guitar.name, ascending: true)]

			guitarsController = NSFetchedResultsController(
				fetchRequest: guitarRequest,
				managedObjectContext: persistence.container.viewContext,
				sectionNameKeyPath: nil,
				cacheName: nil
			)

			// Construct a fetch request to show the 10 highest-priority,
			// incomplete items from open guitars.
			let setupRequest: NSFetchRequest<Setup> = Setup.fetchRequest()
			setupRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Setup.createdOn, ascending: false)]

			setupsController = NSFetchedResultsController(
				fetchRequest: setupRequest,
				managedObjectContext: persistence.container.viewContext,
				sectionNameKeyPath: nil,
				cacheName: nil
			)

			let tuningRequest: NSFetchRequest<Tuning> = Tuning.fetchRequest()
			tuningRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Tuning.name, ascending: true)]
			tuningsController = NSFetchedResultsController(
				fetchRequest: tuningRequest,
				managedObjectContext: persistence.container.viewContext,
				sectionNameKeyPath: nil,
				cacheName: nil
			)

			super.init()

			guitarsController.delegate = self
			tuningsController.delegate = self
			setupsController.delegate = self

			do {
				try guitarsController.performFetch()
				try setupsController.performFetch()
				try tuningsController.performFetch()
				guitars = guitarsController.fetchedObjects ?? []
				setups = setupsController.fetchedObjects ?? []
				tunings = tuningsController.fetchedObjects ?? []
			} catch {
				print("Failed to fetch initial data.")
			}
		}

		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			if let newGuitars = controller.fetchedObjects as? [Guitar] {
				guitars = newGuitars
			} else if let newTunings = controller.fetchedObjects as? [Tuning] {
				tunings = newTunings
			} else if let newSetups = controller.fetchedObjects as? [Setup] {
				setups = newSetups
			}
		}

		func addSampleData() {
			persistence.deleteAll()
			try? persistence.createSampleData()
		}
	}

}
