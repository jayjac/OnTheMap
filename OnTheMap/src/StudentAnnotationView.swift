//
//  StudentAnnotationView.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 04/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import MapKit

enum AnnotationState {
    case normal
    case focused
}
//graph.facebook.com/v2.10/{user-id}/picture?height=150&width=150

class StudentAnnotationView: MKAnnotationView {
    
    @IBOutlet weak var studentImageView: UIImageView!
    @IBOutlet weak var calloutView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!


    
    override var reuseIdentifier: String? {
        return "pin"
    }
    
    override var annotation: MKAnnotation? {
        didSet {
            guard let annotation = annotation as? StudentLocationAnnotation else { return }
            let studentInformation = annotation.studentInformation
            
            let firstName = studentInformation.firstName ?? ""
            let lastName = studentInformation.lastName ?? ""
            let id = studentInformation.uniqueKey
            let facebookId = SessionManager.default.identity?.facebookId
            if id == SessionManager.default.loginSuccess?.key && facebookId != nil {
                if let url = URL(string: "https://graph.facebook.com/v2.10/\(facebookId!)/picture?height=50&width=50"),
                    let data = try? Data.init(contentsOf: url) {
                    studentImageView.image = UIImage(data: data)
                    studentImageView.layer.cornerRadius = 10.0
                    studentImageView.clipsToBounds = true
                }
                
            } else {
                studentImageView.image = UIImage(named: "student")
                studentImageView.layer.cornerRadius = 0.0
                studentImageView.clipsToBounds = false
            }
            if firstName.isEmpty && lastName.isEmpty {
                nameLabel.text = "Name not specified"
                nameLabel.textColor = UIColor.gray
            } else {
               nameLabel.text = "\(firstName) \(lastName)"
                nameLabel.textColor = UIColor.black
            }
            if let mediaURL = studentInformation.mediaURL {
                urlLabel.text = mediaURL
                urlLabel.textColor = UIColor.black
            } else {
                urlLabel.text = "No URL"
                urlLabel.textColor = UIColor.gray
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        frame.size = CGSize(width: 20, height: 20)
        calloutView.layer.shadowOpacity = 0.4
        calloutView.layer.shadowColor = UIColor.black.cgColor
        calloutView.layer.shadowRadius = 2.0
        calloutView.layer.shadowOffset = CGSize(width: 0, height: 0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(calloutWasTapped))
        tapGesture.cancelsTouchesInView = true
        calloutView.addGestureRecognizer(tapGesture)
    }
    
    

    
    func dropPinIfNeeded() {
        guard let annotation = self.annotation as? StudentLocationAnnotation, !annotation.hasPinAlreadyBeenDropped else { return }
        annotation.setPinDropped()
        self.layer.transform = CATransform3DMakeTranslation(0.0, -400.0, 0.0)
        UIView.animate(withDuration: 0.6, delay: 0.5, options: [.curveEaseOut], animations: {
            self.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
    
    
    @objc private func calloutWasTapped() {
        guard let studentAnnotation = annotation as? StudentLocationAnnotation else { return }
        let studentInfo = studentAnnotation.studentInformation
        studentInfo.openMediaURL()
    }



    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.calloutView.frame
        var isInside = rect.contains(point)
        if(!isInside) {
            for view in self.subviews {
                isInside = view.frame.contains(point)
                break;
            }
        }
        return isInside
    }
    
    func animateAnnotation(to state: AnnotationState) {
        let scale: CGFloat
        let hidden: Bool
        switch state {
        case .normal:
            scale = 1.0
            hidden = true
            
        case .focused:
            scale = 1.6
            hidden = false
            calloutView.bringSubview(toFront: self)
        }
        calloutView.isHidden = hidden
        calloutView.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
            self.studentImageView.layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
        }, completion: nil)
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
            self.calloutView.alpha = 1.0
            
        }, completion: nil)
    }
    


}
