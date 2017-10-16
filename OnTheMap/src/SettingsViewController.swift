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

    @IBOutlet weak var tableViewController: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewController.dataSource = self
        tableViewController.rowHeight = UITableViewAutomaticDimension
        tableViewController.estimatedRowHeight = 100.0
    }


}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pictureTableViewCell") as! PictureSettingsTableViewCell
            let identity = SessionManager.default.identity
            cell.firstNameTextField.text = identity?.firstName
            cell.lastNameTextField.text = identity?.lastName
            let imgData: Data?
            if let facebookId = identity?.facebookId {
                let urlString = "https://graph.facebook.com/" + facebookId + "/picture?width=150&height=150"
                let url = URL(string: urlString)!
                imgData = try? Data.init(contentsOf: url)
            } else {
                imgData = nil
            }
            cell.profilePictureImageView.image = imgData != nil ? UIImage(data: imgData!) : nil
            return cell
        } else {
            let cell = tableViewController.dequeueReusableCell(withIdentifier: "myLocationCell") as! MyLocationTableViewCell
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
}
