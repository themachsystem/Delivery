//
//  Venue.swift
//  Delivery
//
//  Created by suitecontrol on 9/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import UIKit

class Venue: NSObject {
    public enum Status {
        case open
        case closed
        case comingSoon
    }
    
    /**
     * Venue's unique id
     */
    var id: Int
    
    /**
     * Venue's name
     */
    var name: String
    
    /**
     * Phone number
     */
    var phone: String!
    
    var cardImageUrl: String!
    var thumbnailImageUrl: String!
    var bannerImageUrl: String!

    /**
     * Venue's opening time
     */
    var openTime: Date?
    
    /**
     * Venue's closing time
     */
    var closeTime: Date?
        
    /**
     * The venue's status
     */
    var status: String!
    
    /**
     * The venue type
     */
    var group: String!
    
    /**
     * The wait time in minutes (if any)
     */
    var waitTime = 0
    
    /**
     * Returns true if delivery option is available for this venue.
     */
    var deliveryAvailable = false
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
