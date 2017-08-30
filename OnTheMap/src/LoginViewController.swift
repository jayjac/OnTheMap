//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 04/08/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController, UdacitySessionDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentLocation()
        //testUdacityParse()
    }
    
    
    func sessionReturnedError(_ error: Error) {
        
    }
    
    func sessionWasAccepted(_ response: String) {
        
    }
    
    @IBAction func logInWasTapped(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text, !username.isEmpty, !password.isEmpty else { return }
        
        NetworkHandler.shared.requestSession(for: username, with: password, notify: self)
    }
    
    
    func testUdacityParse() {
        let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
        let request = NSMutableURLRequest(url: url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            if let data = data {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        let results = jsonObject["results"] as! [[String: AnyObject]]
                        print("There were \(results.count) objects found")
                    }
                }
                catch {
                    
                }

            }
        }
        task.resume()
    }

    @IBAction func createAnAccountButtonWasTapped(_ sender: Any) {
        let signupURL = URL(string: "https://www.udacity.com/account/auth#!/signup")!
        UIApplication.shared.openURL(signupURL)
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([.email], viewController: self) { (result: LoginResult) in
            switch result {
            case .success(let grantedPermissions, let declinedPermissions, let token):
                print("signed in with Facebook")
                print(grantedPermissions)
                print(declinedPermissions)
                print(token)
                
            case .cancelled:
                print("user canceled the signup")
                
            case .failed(let error):
                print(error)
            }
        }
        
    }
    

    func getStudentLocation() {
        let components = NSURLComponents(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
        let jsonObject = ["uniqueKey": "myUniqueKeyRightHereYall"]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)!
        let queryItem = URLQueryItem(name: "where", value: jsonString)
        components.queryItems = [queryItem]
        print(components.url!.absoluteString)
    }
    
    
    
    



}
