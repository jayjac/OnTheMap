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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsWereLoaded), name: .studentLocationsWereLoaded, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func studentLocationsWereLoaded() {
        listTableView.reloadData()
    }
}


extension LocationListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationAnnotation.annotationsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LocationListCell else {
            fatalError("Could not dequeue the correct cell for the LocationList view")
        }
        let studentInformation = StudentLocationAnnotation.annotationsArray[indexPath.row].studentInformation
        cell.setup(with: studentInformation)

        return cell
    }
    
}


extension LocationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let studentInfo = StudentLocationAnnotation.annotationsArray[indexPath.row].studentInformation
        studentInfo.openMediaURL()
    }
}
