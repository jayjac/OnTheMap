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
        
        observeNotifications()
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.region = region
        mapView.delegate = self
       
        GUI.showOverlaySpinnerOverMainController()
        
    }
    
    
    private func observeNotifications() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(loadingURLError(notification:)), name: .loadingURLErrorNotification, object: nil)
        center.addObserver(self, selector: #selector(studentLocationsWereLoaded), name: .studentLocationsWereLoaded, object: nil)
        center.addObserver(self, selector: #selector(studentLocationsLoadingFailed), name: .studentLocationsLoadingFailed, object: nil)
    }
    

    
    @objc private func studentLocationsLoadingFailed() {
        let payload = AlertPayload(title: "Failed", message: "Could not retrieve student locations")
        GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
    }
    
    
    @objc private func loadingURLError(notification: Notification) {
        guard let url = notification.object as? URL else { return }
        let payload = AlertPayload(title: "Error", message: "Could not open url \(url.absoluteString)")
        GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
    }
    
    @objc private func studentLocationsWereLoaded() {
        GUI.removeOverlaySpinner()
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(LocationManager.default.studentLocationAnnotations)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    
    
    func studentLocation(failedToRetrieveLocations error: NSError) {
        let payload = AlertPayload(title: "Error", message: error.localizedDescription)
        GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
    }
    

}
