//
//  VenueManager.swift
//  Delivery
//
//  Created by suitecontrol on 9/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import UIKit
import Alamofire

class VenueManager: NSObject {
    static let shared = VenueManager()
    
    /**
     * A list of venues fetched from API
     */
    var venues = [Venue]()
    
    /**
     * Downloads nearby venues from Boppl API and calls a handler upon completion.
     */
    func downloadNearbyVenues(lat: Double, long: Double, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        AF.request("https://services.boppl.me/api/v1/api/venues?user-lat=\(lat)&user-lon=\(long)").responseJSON {[weak self] response in
            switch response.result {
            case .success(let json):
                guard let jsonArray = json as? [[String:Any]] else {
                    completionHandler(false, "unable to parse JSON")
                    return
                }
                var newVenues = [Venue]()
                for venueDict in jsonArray {
                    if let venue = self?.venueFromJSON(venueDict) {
                        newVenues.append(venue)
                    }
                }
                self?.venues = newVenues
                completionHandler(true, nil)
            case .failure(let error):
                completionHandler(false, error.errorDescription)
            }
        }
    }
    
    //MARK: - Private
    /**
     * Reads json dictionary and returns into Venue object
     */
    private func venueFromJSON(_ dictionary: [String:Any]) -> Venue? {
        guard let id = dictionary["id"] , let name = dictionary["name"] as? String else {
            return nil
        }
        let venue = Venue(id: id as! Int, name: name)
        if let contact = dictionary["contact"] as? [String:String], let phone = contact["phone"] {
            venue.phone = phone
        }
        let cardImageUrl = dictionary["image_card_url"] as? String
        let thumbnailImageUrl = dictionary["image_thumb_url"] as? String
        let bannerImageUrl = dictionary["image_banner_url"] as? String
        let status = dictionary["status"] as? String
        let group = dictionary["group"] as? String
        let waitTime = dictionary["wait_time_min"] as! Int
        if let orderTypes = dictionary["order_types"] as? [String], orderTypes.contains("DELIVER_ADDRESS") {
            venue.deliveryAvailable = true
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let openTime = dictionary["open_time"] as? String {
            venue.openTime = dateFormatter.date(from: openTime)
        }
        if let closeTime = dictionary["close_time"] as? String {
            venue.closeTime = dateFormatter.date(from: closeTime)
        }
        
        venue.cardImageUrl = cardImageUrl
        venue.thumbnailImageUrl = thumbnailImageUrl
        venue.bannerImageUrl = bannerImageUrl
        venue.status = status
        venue.group = group
        venue.waitTime = waitTime
        return venue
    }
}
