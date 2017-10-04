//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 22/08/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

enum AnnotationState {
    case normal
    case focused
}

class MapViewController: UIViewController, MKMapViewDelegate, StudentLocationDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private var studentLocations: [StudentLocation]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let center = CLLocationCoordinate2D(latitude: 48.8886976, longitude: 2.4065027)
        let span = MKCoordinateSpan(latitudeDelta: 50.0, longitudeDelta: 50.0)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.region = region
        
        mapView.delegate = self
        LocationManager.default.retrieveStudentLocations(andNotify: self)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") {
            annotationView.annotation = annotation
            return annotationView
        }
        else {
            let nib = UINib(nibName: "StudentAnnotationView", bundle: nil)
            guard let studentAnnotationView = nib.instantiate(withOwner: nil, options: nil)[0] as? StudentAnnotationView else { return nil }
            studentAnnotationView.annotation = annotation
            studentAnnotationView.isEnabled = true
            return studentAnnotationView
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.animateAnnotation(view, to: .focused)
        guard let studentAnnotationView = view as? StudentAnnotationView else { return }
        studentAnnotationView.calloutView.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.animateAnnotation(view, to: .normal)
        guard let studentAnnotationView = view as? StudentAnnotationView else { return }
        studentAnnotationView.calloutView.isHidden = true
    }
    
    private func animateAnnotation(_ view: UIView, to state: AnnotationState) {
        let scale: CGFloat
        switch state {
        case .normal:
            scale = 1.0
            
        case .focused:
            scale = 1.6
        }
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: [.curveEaseOut], animations: {
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    
    func studentLocation(failedToRetrieveLocations error: NSError) {
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    func studentLocation(didRetrieveLocations locations: [StudentLocation]) {
        self.studentLocations = locations
        mapView.addAnnotations(locations)
    }

}
