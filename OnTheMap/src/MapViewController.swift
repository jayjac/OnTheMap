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

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let center = CLLocationCoordinate2D(latitude: 48.8886976, longitude: 2.4065027)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.region = region
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Home"
        annotation.subtitle = "59 rue Gutenberg"
        mapView.addAnnotation(annotation)
        
        
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
        let leftCalloutView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        leftCalloutView.backgroundColor = UIColor.blue
        let rightCalloutView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        rightCalloutView.backgroundColor = UIColor.brown
        annotationView.leftCalloutAccessoryView = leftCalloutView
        annotationView.rightCalloutAccessoryView = rightCalloutView
        return annotationView
    }

}
