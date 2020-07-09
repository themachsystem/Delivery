//
//  VenueListController.swift
//  Delivery
//
//  Created by suitecontrol on 9/7/20.
//  Copyright © 2020 alvis. All rights reserved.
//

import UIKit

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
        venueViewModel.loadBannerImage { image, error in
            DispatchQueue.main.async {
                cell.bannerImageView.image = image
            }
            if error != nil {
                print(error)
            }
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        venueManager.downloadNearbyVenues(lat: location!.latitude, long: location!.longitude, completionHandler: {[weak self] success, error in
            if success {
                self?.tableView.reloadData()
            }
            else {
                print(error)
            }
        })
    }
}
