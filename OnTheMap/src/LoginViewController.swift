//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 04/08/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController, UdacitySessionDelegate, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Delegate methods
    func sessionReturnedError(_ error: LoginError?) {
        guard let error = error else { return }
        let title = "Error \(error.status)"
        let message = error.message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func sessionWasAccepted() {
        let tabbarVC = storyboard!.instantiateViewController(withIdentifier: "MainTabBarController")
        present(tabbarVC, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField && textField.text!.characters.count > 6 {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField && passwordTextField.text!.characters.count > 6 && usernameTextField.text!.characters.count > 6 {
            logInWasTapped()
        }
        return true
    }
    // MARK: -

    
    @IBAction func logInWasTapped() {
        guard let username = usernameTextField.text, let password = passwordTextField.text, !username.isEmpty, !password.isEmpty else { return }
        SessionManager.default.login(with: username, password: password, notify: self)
    }
    


    @IBAction func createAnAccountButtonWasTapped(_ sender: Any) {
        UIApplication.shared.openURL(UdacityAPI.udacitySignupURL)
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
    

//    func getStudentLocation() {
//        let components = NSURLComponents(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
//        let jsonObject = ["uniqueKey": "myUniqueKeyRightHereYall"]
//        let jsonData = try! JSONSerialization.data(withJSONObject: jsonObject, options: [])
//        let jsonString = String(data: jsonData, encoding: .utf8)!
//        let queryItem = URLQueryItem(name: "where", value: jsonString)
//        components.queryItems = [queryItem]
//        print(components.url!.absoluteString)
//    }
    
    
    
    



}
