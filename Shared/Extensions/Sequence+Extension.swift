//
//  Sequence+Sorting.swift
//  GuitarCloset
//
//  Created by Deirdre Saoirse Moen on 12/31/21.
//

import Foundation

extension Sequence {
	func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
		self.sorted {
			$0[keyPath: keyPath] < $1[keyPath: keyPath]
		}
	}

	func sorted<Value>(by keyPath: KeyPath<Element, Value>, using areInIncreasingOrder: (Value, Value)
					   throws -> Bool) rethrows -> [Element] {
		try self.sorted {
			try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
		}
	}

	func sorted(by sortDescriptor: NSSortDescriptor) -> [Element] {
		self.sorted {
			sortDescriptor.compare($0, to: $1) == .orderedAscending
		}
	}

	func sorted(by sortDescriptors: [NSSortDescriptor]) -> [Element] {
		self.sorted {
			for descriptor in sortDescriptors {
				switch descriptor.compare($0, to: $1) {
				case .orderedAscending:
					return true
				case .orderedDescending:
					return false
				case .orderedSame:
					continue
				}
			}
			return false
		}
	}
}
