//
//  LoginViewController+UdacitySessionDelegate.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 12/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//


import UIKit

extension LoginViewController: UdacitySessionDelegate {
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
        //self.dismiss(animated: true, completion: nil)
        guard let storyboard = storyboard else {
            fatalError("LoginViewController should have a non-nil storyboard property")
        }
        if let success = SessionManager.default.loginSuccess {
            print(success.key)
        }
        let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
        present(mainNavigationController, animated: true, completion: nil)
    }
}
