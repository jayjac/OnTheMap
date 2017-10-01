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
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView.isEnabled = true
            annotationView.image = UIImage(named: "student")
            return annotationView
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("selected annotation view")
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
