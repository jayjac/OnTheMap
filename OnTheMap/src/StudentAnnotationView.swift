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


class StudentAnnotationView: MKAnnotationView {
    
    @IBOutlet weak var studentImageView: UIImageView!
    @IBOutlet weak var calloutView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    private let myStudentImage = UIImage(named: "student_me")
    private let notMyStudentImage = UIImage(named: "student")


    
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
            let key = SessionManager.default.loginSuccess?.key
            studentImageView.image = (id == key) ? myStudentImage : notMyStudentImage
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
    
    /**
     Responds to the user tapping the map annotation callout by opening the URL
    */
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
    
    /**
     Focuses or un-focuses the map annotation view when the user taps on it
     - Parameters:
       - state: AnnotationState enum. 
         * .focused, the annotation image is slightly enlarged and the callout appears.
         * .normal, the callout is discarded and the image returns to normal
     */
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
        calloutView.alpha = hidden ? 1.0 : 0.0
        calloutView.isHidden = hidden
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
            self.studentImageView.layer.transform = CATransform3DMakeScale(scale, scale, 1.0)
        }, completion: nil)

        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
            self.calloutView.alpha = hidden ? 0.0 : 1.0
        }, completion: nil)

    }
    


}
