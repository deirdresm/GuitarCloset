//
//  Tuning+extension.swift
//  GuitarCloset
//
//  Created by Deirdre Saoirse Moen on 2/12/22.
//

import Foundation
import CoreData

extension Tuning {
	enum SortOrder {
		case optimized, name, order
	}

	/// User's preferred order (will be draggable to reorder). Give default of zero.
	var setupOrder: Int16 {
		order
	}
}
