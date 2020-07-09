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
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCurrentLocation() {
        var locationManager = CLLocationManager()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
           currentLoc = locationManager.location
           print(currentLoc.coordinate.latitude)
           print(currentLoc.coordinate.longitude)
        }
        
    }
    
    func testDownloadVenues() {
        let promise = expectation(description: "Status code: 200")
        AF.request("https://services.boppl.me/api/v1/api/venues?user-lat=-33.9525&user-lon=151.1227").responseJSON { response in
            switch response.result {
            case .success(let json):
                if let res = json as? [Any]{
                    
                }
                promise.fulfill()
            case .failure(let error):
                XCTFail("Error: \(error)")
            }
        }
        wait(for: [promise], timeout: 10)
    }
}
