//
//  SampleDataTests.swift
//  Tests iOS
//
//  Created by Deirdre Saoirse Moen on 2/11/22.
//

import XCTest

//
//  DevelopmentTests.swift
//  PortfolioishiOSTests
//
//  Created by Deirdre Saoirse Moen on 1/7/22.
//

import XCTest
import CoreData

@testable import GuitarCloset

class DevelopmentTests: BaseTestCase {

	func testSampleDataCreationWorks() throws {
		try persistence.createSampleData()

		XCTAssertEqual(persistence.count(for: Guitar.fetchRequest()), 5, "There should be 5 sample guitars.")
	}

	func testDeleteAllClearsEverything() throws {
		try persistence.createSampleData()
		persistence.deleteAll()

		XCTAssertEqual(persistence.count(for: Guitar.fetchRequest()), 0, "deleteAll() should leave 0 guitars.")
	}
}
