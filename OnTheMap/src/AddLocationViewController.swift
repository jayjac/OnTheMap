//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 07/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class AddLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    private var reverseGeocoder = CLGeocoder()
    @IBOutlet weak var mapView: MKMapView!
    private var locationManager: CLLocationManager!
    private var mapCenterView: MapCenterView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "MapCenterView", bundle: nil)
        mapCenterView = nib.instantiate(withOwner: nil, options: nil)[0] as! MapCenterView
        view.addSubview(mapCenterView)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var point = mapView.center
        point.y -= 30
        mapCenterView.center = point
        mapCenterView.frame.size = CGSize(width: 170, height: 60)
        mapCenterView.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //locationTextField.becomeFirstResponder()
    }

    @IBAction func searchWasTapped(_ sender: Any) {
        guard let text = locationTextField.text, !text.isEmpty else { return}
        reverseGeocoder.geocodeAddressString(text) { (placemarks: [CLPlacemark]?, error: Error?) in
            guard let placemarks = placemarks else { return }
            
            for placemark in placemarks {
                print(placemark.locality ?? "")
                print(placemark.country ?? "")
            }
            
            let placemark = placemarks[0]
            if let location = placemark.location {
                self.mapView.centerCoordinate = location.coordinate
            }
        }
    }
    
    @IBAction func findMyCurrentLocationWasTapped(_ sender: Any) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        mapView.centerCoordinate = location.coordinate
        mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
    }


}
