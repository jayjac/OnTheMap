//
//  AddURLViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 12/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class AddURLViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var urlBoxBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var urlAddingView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = urlAddingView.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 4.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss(animated:completion:)))
        overlayView.addGestureRecognizer(tapGestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(rollupURLBox(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rolldownURLBox(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        urlTextField.resignFirstResponder()
        super.viewDidDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        urlTextField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        let request = NSMutableURLRequest(url: UdacityAPI.studentLocationURL) //NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue(UdacityAPI.parseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(UdacityAPI.restAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let key = SessionManager.default.loginSuccess?.key, let url = urlTextField.text else { return }
        let myIdentity = SessionManager.default.identity
        let firstName = myIdentity?.firstName ?? ""
        let lastName = myIdentity?.lastName ?? ""
        let dictionary: [String: Any] = ["uniqueKey": key, "mapString": "Montabo", "mediaURL": url, "latitude": 4.93333, "longitude": -52.33333, "firstName": firstName, "lastName": lastName]
        guard let json = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            print("could not parse json")
            return
        }

        request.httpBody = json
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                print("some error occurred")
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }

    @IBAction func cancelButtonWasTapped(_ sender: Any) {
        urlTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }


}
