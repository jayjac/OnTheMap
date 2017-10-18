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
    private static var loadingSpinner: LoadingSpinnerViewController?
    

    
    
    static func initializeMainController(_ controller: UIViewController) {
        mainController = controller
    }
    
    static func deinitMainController() {
        mainController = nil
    }
    
    

    
    /**
     Displays an alert view controller with a 'OK' cancel button
     - Parameters:
       - viewController: the one doing the modal presentation
       - payload: the AlertPayload struct that provides the title and message to display
     */
    static func showSimpleAlert(on viewController: UIViewController, from payload: AlertPayload, withExtra actions: [UIAlertAction]?) {
        DispatchQueue.main.async {
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
        
    }
    
    
    /*static func showOverlaySpinner(on view: UIView, with colors: [UIColor] = [UIColor.white, UIColor.green, UIColor.orange, UIColor.red]) {
        DispatchQueue.main.async {
            overlay?.removeFromSuperview()
            let activityIndicatorOverlay = MaterialActivityIndicatorOverlay(strokeColors: colors)
            overlay = activityIndicatorOverlay
            view.addSubview(activityIndicatorOverlay)
            activityIndicatorOverlay.frame = view.bounds
            activityIndicatorOverlay.startSpinning()
            overlay = activityIndicatorOverlay
        }

    }*/
    
    
    static func showOverlaySpinnerOverMainController() {
        guard let controller = mainController else { return }
        showOverlaySpinnerOn(viewController: controller)
    }
    
    static func showOverlaySpinnerOn(viewController: UIViewController) {
        DispatchQueue.main.async {
            loadingSpinner = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoadingSpinnerViewController") as? LoadingSpinnerViewController
            loadingSpinner?.setStrokeColors([UIColor.white, UIColor.green, UIColor.orange, UIColor.red])
            loadingSpinner?.modalPresentationStyle = .overFullScreen
            viewController.present(loadingSpinner!, animated: false, completion: nil)
        }
    }
    
    static func removeOverlaySpinner() {
        DispatchQueue.main.async {
            loadingSpinner?.dismiss(animated: false, completion: nil)
            loadingSpinner = nil
            /*overlay?.removeFromSuperview()
            overlay = nil*/
        }

    }
}
