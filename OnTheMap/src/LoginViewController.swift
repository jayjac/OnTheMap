//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 04/08/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testUdacityParse()
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



}
