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
    @IBOutlet weak var mapView: MKMapView!
    private var locationManager: CLLocationManager!
    @IBOutlet weak var mapCenterView: MapCenterView!
    @IBOutlet weak var currentLocationButton: UIView!
    @IBOutlet weak var floatingButtonLowerConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBox: UIView!
    var isMapFullyRendered = false
    @IBOutlet weak var leftArrowButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var clippingView: UIView!
    @IBOutlet weak var goBackButton: UIView!
    private let fadeInDelegate = FadeInTransitioningDelegate()
    private var mapString: String?
    private var timer: Timer?
    @IBOutlet weak var locationAddedLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationAddedLabel.alpha = 0.0
        mapView.delegate = self
        mapView.showsPointsOfInterest = true
        mapCenterView.isHidden = true
        
        clippingView.clipsToBounds = true
        leftArrowButtonLeftConstraint.constant = -20.0
        floatingButtonLowerConstraint.constant = -160.0
        locationTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(locationWasTapped))
        mapCenterView.addGestureRecognizer(tapGesture)

        setupShadow(on: currentLocationButton)
        setupShadow(on: goBackButton)
        setupShadow(on: searchBox)
        setupShadow(on: locationAddedLabel)
    }
    

    
    func myLocationWasAdded() {
        mapCenterView.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.locationAddedLabel.alpha = 1.0
        }) { _ in
            SoundPlayer.beep()
            UIView.animateKeyframes(withDuration: 0.5, delay: 3.0, options: [], animations: {
                self.locationAddedLabel.alpha = 0.0
            }, completion: nil)
        }
    }

    
    func animateTextFieldArrow(slideIn: Bool) {
        leftArrowButtonLeftConstraint.constant = slideIn ? 8.0 : -20.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
            self.searchBox.layoutIfNeeded()
        }, completion: nil)
    }

    @IBAction func goBackButtonWasTapped(_ sender: Any) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    

    
    
    @IBAction func leftArrowWasTapped(_ sender: Any) {
        locationTextField.resignFirstResponder()
    }
    
    private func setupShadow(on view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    
    @objc private func locationWasTapped() {
        let addURLViewController = storyboard!.instantiateViewController(withIdentifier: "AddURLViewController") as! AddURLViewController
        
        addURLViewController.modalPresentationStyle = .overFullScreen
        addURLViewController.coordinates = mapView.centerCoordinate
        addURLViewController.mapString = mapString
        present(addURLViewController, animated: false, completion: nil)
    }


    func animateFloatingButton() {
        if isMapFullyRendered {
            self.floatingButtonLowerConstraint.constant = 60
            let delay = 0.8
            UIView.animate(withDuration: 0.5, delay: delay, options: [.curveEaseOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }

    }


    private func reverseGeocode(text: String) {
        mapCenterView.isHidden = true
        LocationManager.default.reverseGeocode(text: text) { (placemarks: [CLPlacemark]?, error: Error?) in
            GUI.removeOverlaySpinner()
            if let error = error {
                let payload = AlertPayload(title: "Not found", message: "\(error.localizedDescription)")
                GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
                return
            }
            //GUI.removeOverlaySpinner()
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks[0]
            if let location = placemark.location {
                DispatchQueue.main.async {
                    self.mapString = placemark.locality
                    let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                    let region = MKCoordinateRegion(center: location.coordinate, span: span)
                    self.mapView.setRegion(region, animated: true)
                    self.mapCenterView.isHidden = false
                }
            }
        }
    }
    
    func searchForInputAddress() {
        guard let text = locationTextField.text, !text.isEmpty else {
            let payload = AlertPayload(title: "Empty field", message: "Please provide a location to search for")
            GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
            return
        }
        GUI.showOverlaySpinnerOn(viewController: self)
        reverseGeocode(text: text)
        timeOutTimerAfter()
    }
    
    @IBAction func searchWasTapped(_ sender: Any) {
        searchForInputAddress()
    }
    
    private func timeOutTimerAfter(seconds: TimeInterval = 8.0) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(requestTimedOut), userInfo: nil, repeats: false)
    }
    
    @objc private func requestTimedOut() {
        if LocationManager.default.isGeocoding {
            GUI.removeOverlaySpinner()
            LocationManager.default.cancelGeoCoding()
            let payload = AlertPayload(title: "Time out", message: "Could not find the required location fast enough. Please check your internet or 3G connection and try again later.")
            GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
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
        mapView.setCenter(location.coordinate, animated: true)
        mapCenterView.isHidden = false
        locationManager.stopUpdatingLocation()
    }


}
