//
//  Maker+Extension.swift
//  GuitarCloset
//
//  Created by Deirdre Saoirse Moen on 1/28/23.
//

import Foundation

extension Maker {

	static var sampleMaker: Maker {
		let controller = Persistence.preview
		let viewContext = controller.container.viewContext

		let maker = Maker(context: viewContext)
		maker.name = "Fender"
		return maker
	}
}
