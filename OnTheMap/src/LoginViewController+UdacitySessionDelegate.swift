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
        let payload = AlertPayload(title: title, message: message)
        GUI.showSimpleAlert(on: self, from: payload, withExtra: nil)
    }
    
    func sessionWasAccepted() {
        GUI.removeOverlaySpinner()
        guard let storyboard = storyboard else {
            fatalError("LoginViewController should have a non-nil storyboard property")
        }
        
        let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController")
        present(mainNavigationController, animated: true, completion: nil)
    }
}
