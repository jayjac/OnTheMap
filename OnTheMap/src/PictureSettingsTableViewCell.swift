//
//  PictureSettingsTableViewCell.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 16/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class PictureSettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePictureImageView.clipsToBounds = true
    }

}
