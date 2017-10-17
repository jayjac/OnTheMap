//
//  LoginViewController+UdacitySessionDelegate.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 12/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//


import UIKit

extension LoginViewController: UdacitySessionDelegate {
    
    
    
    func sessionReturnedError(_ error: LoginError?) {
        GUI.removeOverlaySpinner()
        guard let error = error else { return }
        let title = "Error \(error.status)"
        let message = error.message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func sessionWasAccepted() {
        GUI.removeOverlaySpinner()
        guard let storyboard = storyboard else {
            fatalError("LoginViewController should have a non-nil storyboard property")
        }
        
        let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
        present(mainNavigationController, animated: true, completion: nil)
        //RetrieveUserInfoViewController
        /*let vc = storyboard.instantiateViewController(withIdentifier: "RetrieveUserInfoViewController")
        present(vc, animated: true, completion: nil)*/
    }
}
