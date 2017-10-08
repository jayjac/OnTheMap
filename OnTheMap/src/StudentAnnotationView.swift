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


    
    override var reuseIdentifier: String? {
        return "pin"
    }
    
    override var annotation: MKAnnotation? {
        didSet {
            guard let annotation = annotation as? StudentLocation else { return }
            let firstName = annotation.firstName ?? ""
            let lastName = annotation.lastName ?? ""
            if firstName.isEmpty && lastName.isEmpty {
                nameLabel.text = "Name not specified"
                nameLabel.textColor = UIColor.gray
            } else {
               nameLabel.text = "\(firstName) \(lastName)"
                nameLabel.textColor = UIColor.black
            }
            if let mediaURL = annotation.mediaURL {
                urlLabel.text = mediaURL.absoluteString
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
        guard let annotation = self.annotation as? StudentLocation, !annotation.hasPinAlreadyBeenDropped else { return }
        annotation.setPinDropped()
        self.layer.transform = CATransform3DMakeTranslation(0.0, -400.0, 0.0)
        UIView.animate(withDuration: 0.5) {
            self.layer.transform = CATransform3DIdentity
        }
    }
    
    
    @objc private func calloutWasTapped() {
        guard var url = URL(string: urlLabel.text!) else { return }
        if url.scheme == nil {
            var urlComponents = URLComponents(string: url.absoluteString)!
            urlComponents.scheme = "http"
            url = urlComponents.url!
            
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        } else {
            NotificationCenter.default.post(name: .loadingURLErrorNotification, object: url)
        }
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
