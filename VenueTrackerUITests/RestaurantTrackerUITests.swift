//
//  VenueTrackerUITests.swift
//  VenueTrackerUITests
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import XCTest

class VenueTrackerUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTableView() {
        let app = XCUIApplication()
        
        let tableView = app.tables.element
        sleep(20)
        
        XCTAssertTrue(tableView.exists)
        
        let cell = tableView.cells.element(boundBy: 0)
        XCTAssertTrue(cell.exists)
    }
    
    func testFavoriteButton() {
        let app = XCUIApplication()

        let tableView = app.tables.element

        XCTAssertTrue(tableView.exists)

        let cell = tableView.cells.element(boundBy: 0)
        let button = cell.buttons.element(boundBy: 0)
        XCTAssertTrue(button.exists)
        
        let oldImage = button.images.element(boundBy: 0)
        
        button.tap()
        
        sleep(5)

        let newImage = button.images.element(boundBy: 0)
        
        XCTAssert(oldImage != newImage)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
