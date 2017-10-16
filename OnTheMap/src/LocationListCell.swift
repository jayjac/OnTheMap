//
//  LocationListCell.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 26/09/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class LocationListCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var mapStringLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    

    
    /**
      Populates the cell with the information the corresponding student provided
      - Parameters:
        - studentInformation: the student data to fill the cell with
     */
    func setup(with studentInformation: StudentInformation) {
        let firstName = studentInformation.firstName ?? "No first name"
        let lastName = studentInformation.lastName ?? "No last name"
        let url = studentInformation.mediaURL ?? "no url"
        nameLabel.text = firstName + " " + lastName
        urlLabel.text = url
        mapStringLabel.text = studentInformation.mapString
        if let date = studentInformation.updatedAt {
            dateLabel.text = LocationListCell.dateFormatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
    }

}
