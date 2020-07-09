//
//  VenueCell.swift
//  Delivery
//
//  Created by suitecontrol on 9/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import UIKit

class VenueCell: UITableViewCell {
    @IBOutlet weak var bannerImageView: RoundedImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var openingHoursLabel: UILabel!
    @IBOutlet weak var waitTimeLabel: RoundedLabel!
    @IBOutlet weak var phoneLabel: RoundedLabel!
    @IBOutlet weak var offlineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
