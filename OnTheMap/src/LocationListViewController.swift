//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 26/09/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    let cellReuseIdentifier = "LocationListCell"
    
    

}


extension LocationListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationManager.default.studentLocations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LocationListCell else {
            fatalError("Could not dequeue the correct cell for the LocationList view")
        }
        let student = LocationManager.default.studentLocations[indexPath.row]
        let firstName = student.firstName ?? ""
        let lastName = student.lastName ?? ""
        cell.nameLabel.text = firstName + " " + lastName
        return cell
    }
    
}
