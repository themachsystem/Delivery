//
//  LocationManager.swift
//  Delivery
//
//  Created by suitecontrol on 9/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import UIKit
import CoreLocation

extension CLLocation {
    /**
     * Submits a reverse-geocoding request for the specified location and returns the city and country name.
     */
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
    func locationDidFailToUpdate(error: String)
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
                guard let city = city, error == nil else {
                    self?.delegate?.locationDidFailToUpdate(error: error!.localizedDescription)
                    return
                }
                self?.delegate?.locationDidUpdate(currentLocation: Location(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude, name: city))
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
