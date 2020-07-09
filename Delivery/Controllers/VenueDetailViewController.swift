//
//  VenueDetailViewController.swift
//  Delivery
//
//  Created by suitecontrol on 9/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import UIKit

class VenueDetailViewController: UITableViewController {
    @IBOutlet weak var headerView: VenueHeaderView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    var venue: VenueViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateHeaderView()
        updateVenueInfoView()
    }

    //MARK: - Private
    private func updateHeaderView() {
        venue.loadBannerImage { [weak self] image, error in
            self?.headerView.bannerImageView.image = image
        }
        venue.loadThumbnailImage { [weak self] image, error in
            self?.headerView.logoImageView.image = image
        }
    }
    
    private func updateVenueInfoView() {
        nameLabel.text = venue.name
        descriptionLabel.text = venue.descriptionText
        if let phone = venue.phone {
            phoneLabel.text = "Phone: \(phone)"
        }
        if let address = venue.address {
            addressLabel.text = "Address: \(address)"
        }
        if let website = venue.website {
            websiteLabel.text = "Website: \(website)"
        }
    }
}
