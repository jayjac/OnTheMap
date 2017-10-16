//
//  GUI.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 15/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//


import UIKit

struct AlertPayload {
    let title: String
    let message: String
}


/**
 This struct performs repetitive actions on views, like presenting alert view controllers, showing the spinning icon..
 */
struct GUI {
    
    private static var overlay: MaterialActivityIndicatorOverlay?
    private static var mainController: UIViewController?
    
    
    
    static func initializeMainController(_ controller: UIViewController) {
        mainController = controller
    }
    
    
    static func showOverlaySpinnerOverMainController() {
        guard let controller = mainController else { return }
        showOverlaySpinner(on: controller.view)
    }
    
    /**
     Displays an alert view controller with a 'OK' cancel button
     - Parameters:
       - viewController: the one doing the modal presentation
       - payload: the AlertPayload struct that provides the title and message to display
     */
    static func showSimpleAlert(on viewController: UIViewController, from payload: AlertPayload, withExtra actions: [UIAlertAction]?) {
        let alert = UIAlertController(title: payload.title, message: payload.message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        if let actions = actions {
            for action in actions {
                alert.addAction(action)
            }
        }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    static func showOverlaySpinner(on view: UIView, with colors: [UIColor] = [UIColor.white, UIColor.green, UIColor.orange, UIColor.red]) {
        overlay?.removeFromSuperview()
        let activityIndicatorOverlay = MaterialActivityIndicatorOverlay(strokeColors: colors)
        overlay = activityIndicatorOverlay
        view.addSubview(activityIndicatorOverlay)
        activityIndicatorOverlay.frame = view.bounds
        activityIndicatorOverlay.startSpinning()
        overlay = activityIndicatorOverlay
    }
    
    static func removeOverlaySpinner() {
        overlay?.removeFromSuperview()
        overlay = nil
    }
}
