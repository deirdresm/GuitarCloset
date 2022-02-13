//
//  Tests_macOS.swift
//  UI Tests macOS
//
//  Created by Deirdre Saoirse Moen on 2/12/22.
//

import XCTest

class Tests_macOS: XCTestCase {

	var app: XCUIApplication!

	override func setUp() {
		continueAfterFailure = false

		app = XCUIApplication()
		app.launchArguments.append("enable-testing")
		app.activate()
		sleep(1)
		print("app launched - \(app.launchArguments)")
	}

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
