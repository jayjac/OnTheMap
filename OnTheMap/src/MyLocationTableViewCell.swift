//
//  MyLocationTableViewCell.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 16/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class MyLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var mapStringLabel: UILabel!
    
    
    func setup(with myLocation: MyLocation) {
        urlLabel.text = myLocation.website
        mapStringLabel.text = myLocation.mapString
    }

}
