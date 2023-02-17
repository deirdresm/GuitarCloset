//
//  Guitar+Preview.swift
//  GuitarCloset
//
//  Created by Deirdre Saoirse Moen on 1/29/23.
//

import Foundation

extension Guitar {
	public static var vinteraJaguar: Guitar {
		let guitar = Guitar(context: Persistence.shared.container.viewContext)
		guitar.maker = Maker.makerFender
		guitar.name = "Vintera '60s Jaguar"
		guitar.numStrings = 6
		guitar.scaleLength = 648
		guitar.scaleLength = 648
		guitar.yearMade = 2019
		guitar.boughtFrom = "Haight Ashbury"
		guitar.bodyMaterial = "Alder"
		return guitar
	}

	public static var playerStrat: Guitar {
		let guitar = Guitar(context: Persistence.shared.container.viewContext)
		guitar.maker = Maker.makerFender
		guitar.name = "Player Stratocaster HSS Plus Top"
		guitar.numStrings = 6
		guitar.scaleLength = 648
		guitar.yearMade = 2019
		guitar.boughtFrom = "Guitar Center San Mateo"
		guitar.bodyMaterial = "Alder"
		return guitar
	}
}
