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
        return LocationManager.default.studentLocationAnnotations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LocationListCell else {
            fatalError("Could not dequeue the correct cell for the LocationList view")
        }
        let student = LocationManager.default.studentLocationAnnotations[indexPath.row].studentInformation
        let firstName = student.firstName ?? "No first name"
        let lastName = student.lastName ?? "No last name"
        let url = student.mediaURL ?? "no url"
        cell.nameLabel.text = firstName + " " + lastName
        cell.urlLabel.text = url
        return cell
    }
    
}


extension LocationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let studentInfo = LocationManager.default.studentLocationAnnotations[indexPath.row].studentInformation
        studentInfo.openMediaURL()
    }
}
