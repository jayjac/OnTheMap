//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 04/08/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var activityIndicatorOverlay = MaterialActivityIndicatorOverlay(strokeColors: [UIColor.white, UIColor.green, UIColor.orange, UIColor.red])
    
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
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let username = usernameTextField.text, let password = passwordTextField.text, !username.isEmpty, !password.isEmpty else {
            //TODO: show alert if username or password missing
            return
        }
        self.view.addSubview(activityIndicatorOverlay)
        activityIndicatorOverlay.frame = view.bounds
        activityIndicatorOverlay.startSpinning()
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
    
    
    
    
    



}
