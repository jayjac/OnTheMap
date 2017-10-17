//
//  PictureSettingsTableViewCell.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 16/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit


fileprivate let unknownFieldColor = UIColor(white: 0.0, alpha: 0.8)

class PictureSettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePictureImageView.clipsToBounds = true
        setupUserInfo()
    }
    
    
    private func setupUserInfo() {
        let identity = SessionManager.default.identity
        if let firstName = identity?.firstName {
            firstNameLabel.text = firstName
            firstNameLabel.textColor = UIColor.black
        } else {
            firstNameLabel.text = "Unknown first name"
            firstNameLabel.textColor = unknownFieldColor
        }
        if let lastName = identity?.lastName {
            lastNameLabel.text = lastName
            lastNameLabel.textColor = UIColor.black
        } else {
            lastNameLabel.text = "Unknown last name"
            lastNameLabel.textColor = unknownFieldColor
        }
        
        let imgData: Data?
        if let facebookId = identity?.facebookId {
            let urlString = "https://graph.facebook.com/" + facebookId + "/picture?width=150&height=150"
            let url = URL(string: urlString)!
            imgData = try? Data.init(contentsOf: url)
        } else {
            imgData = nil
        }
        profilePictureImageView.image = imgData != nil ? UIImage(data: imgData!) : UIImage(named: "big_student_me")
    }

}
