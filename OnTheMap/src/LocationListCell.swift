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
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    

    
    /**
      Populates the cell with the information the corresponding student provided
      - Parameters:
        - studentInformation: the student data to fill the cell with
     */
    func setup(with studentInformation: StudentInformation) {
        let firstName = studentInformation.firstName ?? ""
        let lastName = studentInformation.lastName ?? ""
        if firstName.isEmpty && lastName.isEmpty {
            nameLabel.text = "Name not specified"
            nameLabel.textColor = UIColor.darkGray
        } else {
            nameLabel.text = firstName + " " + lastName
            nameLabel.textColor = UIColor.black
        }
        let url = studentInformation.mediaURL ?? "no url"
        urlLabel.text = url
        if let mapString = studentInformation.mapString, !mapString.isEmpty {
            mapStringLabel.text = mapString
            mapStringLabel.textColor = UIColor.black
        } else {
            mapStringLabel.text = "Unknown location"
            mapStringLabel.textColor = UIColor.darkGray
        }
        
        if let date = studentInformation.updatedAt {
            dateLabel.text = "(" + LocationListCell.dateFormatter.string(from: date) + ")"
        } else {
            dateLabel.text = ""
        }
    }

}
