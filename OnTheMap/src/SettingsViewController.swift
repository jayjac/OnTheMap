//
//  SettingsViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 14/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import FacebookCore

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(rowWasDeleted(notification:)), name: .removedMyLocation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(myLocationWasAdded), name: .loadingMyLocationsSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(myLocationsLoadingFailed(notification:)), name: .loadingMyLocationsFailed, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func rowWasDeleted(notification: Notification) {
        guard let index = notification.object as? Int else {
            fatalError("Notification object should be an Int in SettingsViewController")
        }
        let indexPath = IndexPath(row: index + 1, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    @objc private func myLocationWasAdded() {
        tableView.reloadData()
    }
    
    @objc private func myLocationsLoadingFailed(notification: Notification) {
        guard let error = notification.object as? Error else {
            fatalError("Notification object should be an error in SettingsViewController")
        }
        let payload = AlertPayload(title: "Error", message: "Could not retrieve all my locations \(error.localizedDescription)")
        GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
    }


}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pictureTableViewCell") as! PictureSettingsTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myLocationCell") as! MyLocationTableViewCell
            let row = indexPath.row - 1
            let myLocation = LocationManager.default.myLocations[row]
            cell.setup(with: myLocation)
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + LocationManager.default.myLocations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let myLocation = LocationManager.default.myLocations[indexPath.row - 1]
        guard let website = myLocation.website, let url = URL(string: website) else { return }
        UIApplication.shared.openURL(url)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row - 1
        LocationManager.default.deleteLocation(at: index)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let row = indexPath.row
        return row != 0
    }
}
