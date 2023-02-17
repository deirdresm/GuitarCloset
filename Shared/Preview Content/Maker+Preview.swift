//
//  Maker+Preview.swift
//  GuitarCloset
//
//  Created by Deirdre Saoirse Moen on 1/29/23.
//

import Foundation

extension Maker {
	public static var makerFender: Maker {
		let maker = Maker(context: Persistence.shared.container.viewContext)
		maker.name = "Fender"
		return maker
	}


}
