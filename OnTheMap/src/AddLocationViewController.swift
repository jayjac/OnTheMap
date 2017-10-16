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


class AddLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    private var reverseGeocoder = CLGeocoder()
    @IBOutlet weak var mapView: MKMapView!
    private var locationManager: CLLocationManager!
    @IBOutlet weak var mapCenterView: MapCenterView!
    @IBOutlet weak var currentLocationButton: UIView!
    @IBOutlet weak var floatingButtonLowerConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBox: UIView!
    private var isMapFullyRendered = false
    @IBOutlet weak var leftArrowButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var clippingView: UIView!
    @IBOutlet weak var goBackButton: UIView!
    private let fadeInDelegate = FadeInTransitioningDelegate()
    private var mapString: String?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsPointsOfInterest = true
        mapCenterView.alpha = 0.0
        clippingView.clipsToBounds = true
        leftArrowButtonLeftConstraint.constant = -20.0
        floatingButtonLowerConstraint.constant = -160.0
        locationTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(locationWasTapped))
        mapCenterView.addGestureRecognizer(tapGesture)

        setupShadow(on: currentLocationButton)
        setupShadow(on: goBackButton)
        setupShadow(on: searchBox)
        
        guard let navController = navigationController else { return }
        navController.isNavigationBarHidden = true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateTextFieldArrow(slideIn: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateTextFieldArrow(slideIn: false)
    }
    
    private func animateTextFieldArrow(slideIn: Bool) {
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
        
        addURLViewController.modalPresentationStyle = .custom
        addURLViewController.transitioningDelegate = fadeInDelegate
        addURLViewController.coordinates = mapView.centerCoordinate
        addURLViewController.mapString = mapString
        present(addURLViewController, animated: true, completion: nil)
    }


    private func animateFloatingButton() {
        if isMapFullyRendered {
            self.floatingButtonLowerConstraint.constant = 60
            let delay = 0.8
            UIView.animate(withDuration: 0.5, delay: delay, options: [.curveEaseOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }

    }

    
    private func fadeInMapCenterView() {
        UIView.animate(withDuration: 0.8, delay: 0.5, options: [.curveEaseOut], animations: {
            self.mapCenterView.alpha = 1.0
        }, completion: nil)
    }
    

    
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        isMapFullyRendered = true
        animateFloatingButton()
        fadeInMapCenterView()
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
                self.mapString = placemark.locality
                self.mapView.setCenter(location.coordinate, animated: true)
            }
        }
    }
    
    @IBAction func findMyCurrentLocationWasTapped(_ sender: Any) {
        //mapRegionChangedProgrammatically = true
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
        //mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
    }


}
