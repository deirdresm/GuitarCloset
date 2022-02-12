//
//  Setup+Extension.swift
//  GuitarCloset
//
//  Created by Deirdre Saoirse Moen on 2/12/22.
//

import Foundation
import CoreData

extension Setup {
	enum SortOrder {
		case optimized, name, createdOn
	}

	var setupCreatedOn: Date {
		createdOn ?? Date()
	}

}
