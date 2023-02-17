//
//  MakersVM.swift
//  GuitarCloset (iOS)
//
//  Created by Deirdre Saoirse Moen on 2/16/23.
//

import CoreData
import Foundation
import SwiftUI

extension MakersView {
	class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
		let persistence: Persistence

		init(persistence: Persistence) {
			self.persistence = persistence
		}
	}
}
