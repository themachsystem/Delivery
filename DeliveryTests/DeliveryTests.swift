//
//  DeliveryTests.swift
//  DeliveryTests
//
//  Created by suitecontrol on 9/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import XCTest
@testable import Delivery
import Alamofire
import CoreLocation

class DeliveryTests: XCTestCase {
    var sut: VenueListController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainNavigationController") as? UINavigationController {
            sut = navController.topViewController as? VenueListController
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSUT_CanBeInstantiated() {
        XCTAssertNotNil(sut)
    }

    func testDownloadVenuesNearBexley() {
        let promise = expectation(description: "Status code: 200")
        VenueManager.shared.downloadNearbyVenues(lat: -33.9525, long: 151.1227) { success, error in
            if success {
                promise.fulfill()
            }
            else if error != nil {
                XCTFail("Error: \(error!)")
            }
        }
        wait(for: [promise], timeout: 10)
    }
}
