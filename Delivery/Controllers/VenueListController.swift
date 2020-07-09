//
//  VenueListController.swift
//  Delivery
//
//  Created by suitecontrol on 9/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import UIKit
import SVProgressHUD

class VenueListController: UITableViewController, LocationUpdater {
    private var location: Location?
    private let venueManager = VenueManager.shared
    private let locationManager = LocationManager()
    private var venues: [Venue] {
        return venueManager.venues
    }
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        fetchNearbyVenues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VenueCell", for: indexPath) as! VenueCell
        let venue = venues[indexPath.row]
        let venueViewModel = VenueViewModel(venue: venue)
        cell.nameLabel.text = venueViewModel.name
        cell.groupLabel.text = venueViewModel.group
        cell.openingHoursLabel.text = venueViewModel.openingHours
        cell.waitTimeLabel.text = "\(venueViewModel.waitTime) MIN"
        cell.waitTimeLabel.isHidden = venueViewModel.waitTime == 0
        cell.distanceLabel.text = "\(venueViewModel.distance)km away"
        if let phone = venueViewModel.phone {
            cell.phoneLabel.text = "Phone: \(phone)"
            cell.phoneLabel.isHidden = false
        }
        else {
            cell.phoneLabel.text = ""
            cell.phoneLabel.isHidden = true
        }
        // If venue status is open, hide offline view and show wait time label and phone label.
        // Otherwise, if it is closed, show offline view and hide wait time and phone labels.
        if venueViewModel.status == "OPEN" {
            cell.offlineLabel.isHidden = true
            cell.waitTimeLabel.isHidden = false
            cell.phoneLabel.isHidden = false
        }
        // COMING SOON or CLOSED
        else {
            cell.offlineLabel.text = venueViewModel.status
            cell.offlineLabel.isHidden = false
            cell.waitTimeLabel.isHidden = true
            cell.phoneLabel.isHidden = true
        }
        venueViewModel.loadCardImage { image, error in
            DispatchQueue.main.async {
                cell.bannerImageView.image = image
            }
            if error != nil {
                print(error)
            }
        }
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowVenueDetail" {
            let cell = sender as! VenueCell
            let indexPath = tableView.indexPath(for: cell)
            let venue = venues[indexPath!.row]
            let controller = segue.destination as! VenueDetailViewController
            controller.venue = VenueViewModel(venue: venue)
        }
    }
    

    //MARK: - LocationUpdater
    func locationDidUpdate(currentLocation: Location) {
        location = currentLocation
        if let locationName = location?.name {
            self.navigationItem.title = "Places near \(locationName)"
        }
        // Only call this once when app starts
        DispatchQueue.once { [weak self] in
            self?.fetchNearbyVenues()
        }
    }
    
    private func fetchNearbyVenues() {
        SVProgressHUD.show()
        venueManager.downloadNearbyVenues(lat: location!.latitude, long: location!.longitude, completionHandler: {[weak self] success, error in
            SVProgressHUD.dismiss()
            if success {
                self?.tableView.reloadData()
            }
            else {
                print(error)
            }
        })
    }
}
