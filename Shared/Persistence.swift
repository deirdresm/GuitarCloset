//
//  Persistence.swift
//  Shared
//
//  Created by Deirdre Saoirse Moen on 2/7/22.
//

import CoreData
import CoreSpotlight
import SwiftUI

/// An environment singleton responsible for managing our Core Data stack,
/// including handling saving, counting fetch requests, tracking awards,
/// and dealing with sample data.

class Persistence: ObservableObject {
	/// The lone CloudKit container used to store all our data.
	let container: NSPersistentCloudKitContainer

    static let shared = Persistence()

    static var preview: Persistence = {
        let previewController = Persistence(inMemory: true)
        let viewContext = previewController.container.viewContext

        do {
			try previewController.createSampleData()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return previewController
    }()

	/// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
	/// or on permanent storage (for use in regular app runs.) Defaults to permanent storage.
	/// - Parameter inMemory: Whether to store this data in temporary memory or not.

    init(inMemory: Bool = false) {
		var isTesting = inMemory
		container = NSPersistentCloudKitContainer(name: "net.deirdre.GuitarCloset", managedObjectModel: Self.model)

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(filePath: "/dev/null")
        }

		container.loadPersistentStores { _, error in
			if let error = error {
				fatalError("Fatal error loading store: \(error.localizedDescription)")
			}

			#if DEBUG
			if isTesting {
				self.deleteAll()
				#if os(macOS)
				#else
				UIView.setAnimationsEnabled(false)
				#endif
			}
			#endif
		}

		container.viewContext.automaticallyMergesChangesFromParent = true
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
		container.viewContext.undoManager = nil
		container.viewContext.shouldDeleteInaccessibleFaults = true

//		if #available(iOS 13, macOS 10.15, *) {
//			// Observe Core Data remote change notifications.
//			NotificationCenter.default.addObserver(
//				self, selector: #selector(type(of: self).storeRemoteChange(_:)),
//				name: .NSPersistentStoreRemoteChange, object: nil)
//		}
    }

	/// Creates example guitars and items to make manual testing easier.
	/// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.

	func createSampleData() throws {
		let viewContext = container.viewContext

		for guitarCounter in 1...5 {
			let guitar = Guitar(context: viewContext)
			guitar.name = "Guitar \(guitarCounter)"
			guitar.model = "Sample Model \(guitarCounter)"
			guitar.purchasedOn = Date()
		}

		for pedalCounter in 1...5 {
			let pedal = Pedal(context: viewContext)
			pedal.name = "Pedal \(pedalCounter)"
			pedal.purchasedOn = Date()
		}
		try viewContext.save()
	}

	/// Saves our Core Data context iff there are changes. This silently ignores
	/// any errors caused by saving, but this should be fine because all our
	/// attributes are optional.

	func save() {
		if container.viewContext.hasChanges {
			try? container.viewContext.save()
		}
	}

	func delete(_ object: NSManagedObject) {
		container.viewContext.delete(object)
	}

	func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
		(try? container.viewContext.count(for: fetchRequest)) ?? 0
	}

	/// Deletes all existing data.
	/// Note: only used in testing.
	func deleteAll() {
		let guitarFetchRequest: NSFetchRequest<NSFetchRequestResult> = Guitar.fetchRequest()
		let guitarBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: guitarFetchRequest)
		_ = try? container.viewContext.execute(guitarBatchDeleteRequest)

		let pedalFetchRequest: NSFetchRequest<NSFetchRequestResult> = Pedal.fetchRequest()
		let pedalBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: pedalFetchRequest)
		_ = try? container.viewContext.execute(pedalBatchDeleteRequest)

		container.viewContext.reset() // reset the container so the view refreshes to the new context container
	}

	static let model: NSManagedObjectModel = {
		guard let url = Bundle.main.url(forResource: "GuitarCloset", withExtension: "momd") else {
			fatalError("Failed to locate model file.")
		}

		guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
			fatalError("Failed to load model file.")
		}

		return managedObjectModel
	}()
}
