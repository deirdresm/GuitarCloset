//
//  Guitar.swift
//  GuitarCloset (iOS)
//
//  Created by Deirdre Saoirse Moen on 2/11/22.
//

import Foundation

import Foundation
import CoreData
import SwiftUI

extension Guitar {
	var guitarName: String {
		name ?? NSLocalizedString("New Guitar", comment: "Create a new guitar")
	}

	var guitarMaker: String {
		maker  ?? NSLocalizedString("New Maker", comment: "Enter guitar maker")
	}

	var guitarColor: String {
		color ?? "Ocean Turquoise"
	}

	var label: LocalizedStringKey {
		// swiftlint:disable:next line_length
		LocalizedStringKey("\(guitarMaker), \(guitarName), \(guitarColor).")
	}


	func guitarSetups(using sortOrder: Setup.SortOrder) -> [Setup] {
		switch sortOrder {
		case .name:
			let sortDescriptor = NSSortDescriptor(keyPath: \Setup.name, ascending: true)
			return self.guitarSetups.sorted(by: sortDescriptor)
		case .createdOn:
			let sortDescriptor = NSSortDescriptor(keyPath: \Setup.createdOn, ascending: false)
			return self.guitarSetups.sorted(by: sortDescriptor)
		case .optimized:
			return guitarSetupsDefaultSorted
		}
	}

	var guitarSetups: [Setup] {
		setups?.allObjects as? [Setup] ?? []
	}

	var guitarSetupsDefaultSorted: [Setup] {
		guitarSetups.sorted { first, second in
			return first.setupCreatedOn < second.setupCreatedOn
		}
	}
}

#if DEBUG
extension Guitar {

	static var example: Guitar {
		let controller = Persistence.preview
		let viewContext = controller.container.viewContext

		let guitar = Guitar(context: viewContext)
		guitar.name = "Stratocaster"
		guitar.bodyMaterial = "Alder"
		guitar.maker = "Fender"
		guitar.series = "Player Plus Top"
		guitar.scaleLength = 648 // 25.5" in mm
		guitar.neckRadius = 241 // 9.5" in mm
		guitar.purchasedOn = Date()
		return guitar
	}
}
#endif
