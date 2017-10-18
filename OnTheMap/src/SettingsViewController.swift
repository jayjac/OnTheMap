//
//  SettingsViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 14/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import FacebookCore


/**
 The optional third tab's View Controller
 */
class SettingsViewController: UIViewController {

    /**
     This tableView has three cell types: 
       - one for the user information and picture.
       - one for the locations the user has added
       - one for the message saying the user has no locations uploaded so far.
     */
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(rowWasDeleted(notification:)), name: .removedMyLocation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removedMyLocationFailed(notification:)), name: .removedMyLocationFailed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(myLocationWasAdded), name: .loadingMyLocationsSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(myLocationsLoadingFailed(notification:)), name: .loadingMyLocationsFailed, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /**
     Removes the row that was just swipe-deleted by the user
     */
    @objc private func rowWasDeleted(notification: Notification) {
        GUI.removeOverlaySpinner()
        guard let index = notification.object as? Int else {
            fatalError("Notification object should be an Int in SettingsViewController")
        }
        let indexPath = IndexPath(row: index + 1, section: 0)
        if LocationManager.default.myLocations.count > 0 {
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else {
            tableView.reloadData()
        }
        
    }
    
    /**
     Notification observer's selector fired when the user uploads a new location/URL to the server
     */
    @objc private func myLocationWasAdded() {
        GUI.removeOverlaySpinner()
        tableView.reloadData()
    }
    
    @objc private func myLocationsLoadingFailed(notification: Notification) {
        GUI.removeOverlaySpinner()
        guard let error = notification.object as? Error else {
            fatalError("Notification object should be an error in SettingsViewController")
        }
        let payload = AlertPayload(title: "Error", message: "Could not retrieve all my locations \(error.localizedDescription)")
        GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
    }
    
    
    /**
     If there was an error while deleting the row, this function gets called
     */
    @objc private func removedMyLocationFailed(notification: Notification) {
        GUI.removeOverlaySpinner()
        guard let error = notification.object as? Error else {
            fatalError("Notification object should be an error in SettingsViewController")
        }
        let payload = AlertPayload(title: "Error", message: error.localizedDescription)
        GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
    }


}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        // First row: user info and profile picture cell
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pictureTableViewCell") as! PictureSettingsTableViewCell
            return cell
        }
        // If the user has uploaded some locations, then those locations are displayed
        else if row > 0 && LocationManager.default.myLocations.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myLocationCell") as! MyLocationTableViewCell
            let row = indexPath.row - 1
            let myLocation = LocationManager.default.myLocations[row]
            cell.setup(with: myLocation)
            return cell
        }
        // If the user has no uploaded locations, displays a default message
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoLocationTableViewCell")
            return cell!
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if LocationManager.default.myLocations.count == 0 {
            return 2 //Profile info + "no location" cells
        } else {
            return 1 + LocationManager.default.myLocations.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let myLocation = LocationManager.default.myLocations[indexPath.row - 1] // index is off by one because of the presence of the "profile info" cell
        myLocation.openMWebsiteURL()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row - 1
        GUI.showOverlaySpinnerOverMainController()
        LocationManager.default.deleteLocation(at: index)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let row = indexPath.row
        return row > 0 && (LocationManager.default.myLocations.count > 0) // only shows the 'delete' button when we are in a 'uploaded location' cell
    }
}
