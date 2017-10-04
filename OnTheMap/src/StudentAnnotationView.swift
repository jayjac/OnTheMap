//
//  StudentAnnotationView.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 04/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import MapKit

class StudentAnnotationView: MKAnnotationView {
    
    @IBOutlet weak var studentImageView: UIImageView!
    @IBOutlet weak var calloutView: UIView!
    
    override var reuseIdentifier: String? {
        return "pin"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calloutView.layer.shadowOpacity = 0.4
        calloutView.layer.shadowColor = UIColor.black.cgColor
        calloutView.layer.shadowRadius = 2.0
        calloutView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

}
