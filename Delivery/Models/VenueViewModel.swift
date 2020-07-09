//
//  VenueViewModel.swift
//  Delivery
//
//  Created by suitecontrol on 9/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import UIKit
import Alamofire

class VenueViewModel: NSObject {
    private let venue: Venue
    private let dateFormatter: DateFormatter
    
    init(venue: Venue) {
        self.venue = venue
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .none
        self.dateFormatter.timeStyle = .short
    }
    
    /**
     * Venue's unique id
     */
    var id: Int {
        return venue.id
    }
    
    /**
     * Venue's name
     */
    var name: String {
        return venue.name
    }
    
    /**
     * Phone number
     */
    var phone: String {
        return venue.phone
    }
    
    func loadCardImage(_ completionHandler: @escaping (UIImage?, String?) -> Void) {
        guard let imageUrl = venue.cardImageUrl else {
            completionHandler(nil, nil)
            return
        }
        loadImage(url: imageUrl, completionHandler: completionHandler)
    }
    
    func loadThumbnailImage(_ completionHandler: @escaping (UIImage?, String?) -> Void) {
        guard let imageUrl = venue.thumbnailImageUrl else {
            completionHandler(nil, nil)
            return
        }
        loadImage(url: imageUrl, completionHandler: completionHandler)
    }

    func loadBannerImage(_ completionHandler: @escaping (UIImage?, String?) -> Void) {
        guard let imageUrl = venue.bannerImageUrl else {
            completionHandler(nil, nil)
            return
        }
        loadImage(url: imageUrl, completionHandler: completionHandler)
    }

    var openingHours: String {
        if openTime != nil && closeTime != nil {
            return "Open \(openTime!) to \(closeTime!)"
        }
        return ""
    }
    
    /**
     * Venue's opening time
     */
    private var openTime: String? {
        guard let openingTime = venue.openTime else { return nil }
        return dateFormatter.string(from: openingTime)
    }
    
    /**
     * Venue's closing time
     */
    private var closeTime: String? {
        guard let closingTime = venue.closeTime else { return nil }
        return dateFormatter.string(from: closingTime)
    }
    
    /**
     * The venue type
     */
    var group: String {
        return venue.group
    }
    
    /**
     * Returns true if delivery option is available for this venue.
     */
    var deliveryAvailable: Bool {
        return venue.deliveryAvailable
    }
    
    /**
     * The wait time in minutes (if any)
     */
    var waitTime: Int {
        return venue.waitTime
    }
    
    /**
     * The venue's status
     */
    var status: String {
        return venue.status
//        switch venue.status {
//        case .open:
//            return "OPEN"
//        case .closed:
//            return "OFFLINE"
//        case .comingSoon:
//            return "COMING SOON"
//        }
    }
    
    //MARK: - Private
    private func loadImage(url: String, completionHandler: @escaping (UIImage?, String?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let imageData):
                completionHandler(UIImage(data: imageData), nil)
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
}
