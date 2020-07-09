//
//  LocationManager.swift
//  Delivery
//
//  Created by suitecontrol on 9/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import UIKit
import CoreLocation

public extension DispatchQueue {

    private static var _onceTracker = [String]()

    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.

     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(block: () ->Void) {
        let onceToken = NSUUID().uuidString
        objc_sync_enter(self); defer { objc_sync_exit(self) }

        if _onceTracker.contains(onceToken) {
            return
        }

        _onceTracker.append(onceToken)
        block()
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

struct Location {
    var longitude: Double
    var latitude: Double
    var name: String?
}

protocol LocationUpdater: AnyObject {
    func locationDidUpdate(currentLocation: Location)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    weak var delegate: LocationUpdater?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            if let location = locationManager.location, delegate != nil {
                location.fetchCityAndCountry {[weak self] city, country, error in
                    guard let city = city, error == nil else { return }
                    self?.delegate?.locationDidUpdate(currentLocation: Location(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude, name: city))
                }
            }
        }
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, delegate != nil {
            location.fetchCityAndCountry {[weak self] city, country, error in
                guard let city = city, error == nil else { return }
                self?.delegate?.locationDidUpdate(currentLocation: Location(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude, name: city))
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
