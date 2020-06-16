//
//  VenueTrackerTests.swift
//  VenueTrackerTests
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import XCTest
@testable import VenueTracker

class VenueTrackerTests: XCTestCase {
    override func setUp()
    {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testVenueFetcherAndPresenter()
    {
        let presenter = VenuePresenter(presentingVCs: [], dataItems: [])
        
        let venueFetcher = VenueFetcher(timeInterval: 15, presenter: presenter, urlOptions: URLOptions(), shouldNavigateBlock: nil)
        venueFetcher.fetch()
        //Wait more than timeout
        sleep(20)
        
        //halt the timer
        venueFetcher.cancelFetching()
        
        XCTAssert(venueFetcher.presenter!.dataItems is [Venue])
    }
}
