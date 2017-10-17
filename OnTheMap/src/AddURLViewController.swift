//
//  AddURLViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 12/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import CoreLocation

class AddURLViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var urlBoxBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var urlAddingView: UIView!
    var coordinates: CLLocationCoordinate2D?
    var mapString: String?
    @IBOutlet weak var mapStringLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = urlAddingView.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 4.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fadeout))
        overlayView.addGestureRecognizer(tapGestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(rollupURLBox(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rolldownURLBox(_:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(locationWasAdded), name: .addingLocationSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(errorAddingLocation(_:)), name: .addingLocationFailed, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        urlTextField.resignFirstResponder()
        super.viewDidDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapStringLabel.text = mapString
        urlTextField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func fadeout() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func locationWasAdded() {
        GUI.removeOverlaySpinner()
        fadeout()
    }
    
    
    @objc private func errorAddingLocation(_ notification: Notification) {
        GUI.removeOverlaySpinner()
        let payload = AlertPayload(title: "Error", message: "Your location could not be sent to the server ")
        GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
    }
    
    @objc private func rollupURLBox(_ notification: Notification) {
        guard let info = notification.userInfo,
            let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let endFrame = info[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }

        let distance = endFrame.height
        self.urlBoxBottomConstraint.constant = distance
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func rolldownURLBox(_ notification: Notification) {
        guard let info = notification.userInfo,
            let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        self.urlBoxBottomConstraint.constant = 0.0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendURLButtonWasTapped(_ sender: Any) {
        guard let url = urlTextField.text, let coordinates = self.coordinates else { return }
        if url.isEmpty {
            let payload = AlertPayload(title: "Empty field", message: "Please provide a URL you would like to share")
            GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
            return
        }
        GUI.showOverlaySpinner(on: self.view)
        LocationManager.default.addLocation(with: url, coordinates: coordinates, mapString: self.mapString)
    }

    @IBAction func cancelButtonWasTapped(_ sender: Any) {
        urlTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }


}
