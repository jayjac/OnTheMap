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





class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let center = CLLocationCoordinate2D(latitude: 48.8886976, longitude: 2.4065027)
        let span = MKCoordinateSpan(latitudeDelta: 50.0, longitudeDelta: 50.0)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.region = region
        
        mapView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(loadingURLError(notification:)), name: .loadingURLErrorNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(studentLocationsWereLoaded), name: .studentLocationsWereLoaded, object: nil)
        LocationManager.default.retrieveStudentLocations()
        
    }
    
    
    @objc private func loadingURLError(notification: Notification) {
        guard let url = notification.object as? URL else { return }
        let alert = UIAlertController(title: "Error", message: "Could not opent url: \(url.absoluteString)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func studentLocationsWereLoaded() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(LocationManager.default.studentLocations)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    
    
    func studentLocation(failedToRetrieveLocations error: NSError) {
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    

}
