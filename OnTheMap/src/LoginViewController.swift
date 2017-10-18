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
            let payload = AlertPayload(title: "Empty field(s)", message: "Both the username and password must be filled out in order to proceed")
            GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
            return
        }
        GUI.showOverlaySpinnerOn(viewController: self)
        SessionManager.default.login(with: .regular, notify: self, credentials: username, password)
    }
    

    


    @IBAction func createAnAccountButtonWasTapped(_ sender: Any) {
        UIApplication.shared.openURL(UdacityAPI.udacitySignupURL)
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([.email], viewController: self) { (result: LoginResult) in
            switch result {
            case .success(_, _, let token):
                GUI.showOverlaySpinnerOn(viewController: self)
                SessionManager.default.login(with: .facebook, notify: self, credentials: token.authenticationToken)
                
            case .cancelled:
                print("user canceled the signup")
                return
                
            case .failed(let error):
                let payload = AlertPayload(title: "Error", message: error.localizedDescription)
                GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
            }
        }
        
    }
    
    
    
    
    



}
