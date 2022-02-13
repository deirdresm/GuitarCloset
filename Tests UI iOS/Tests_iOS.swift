//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Deirdre Saoirse Moen on 2/7/22.
//

import XCTest

@testable import GuitarCloset

class Tests_iOS: XCTestCase {

	var app: XCUIApplication!

	let expectedTabCount = 3

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
		XCTAssertEqual(app.tabBars.buttons.count, expectedTabCount, "There should be \(expectedTabCount) tabs in the app.")
	}

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
