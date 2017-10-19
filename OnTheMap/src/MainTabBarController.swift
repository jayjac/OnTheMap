//
//  MainTabBarController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 30/09/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    @IBOutlet weak var reloadBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let parent = parent else {
            fatalError("MainTabBarController should have a Controller parent")
        }
        GUI.initializeMainController(parent)
        NotificationCenter.default.addObserver(self, selector: #selector(logOutNotification(_:)), name: .logOut, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationManager.default.retrieveStudentLocations(force: true)
        LocationManager.default.retrieveMyLocations()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    @objc private func logOutNotification(_ notification: Notification) {
        guard let parent = parent else {
            fatalError("MainTabBarController should have a (Navigation) Controller parent")
        }
        parent.dismiss(animated: true) { 
            GUI.deinitMainController()
        }
    }
    
    @IBAction func logOutWasTapped(_ sender: Any) {
        GUI.showOverlaySpinnerOverMainController()
        SessionManager.default.logout()
    }
    
    
    @IBAction func reloadWasTapped(_ sender: UIBarButtonItem) {
        GUI.showOverlaySpinnerOverMainController()
        LocationManager.default.retrieveStudentLocations()
    }

    @IBAction func addANewLocationWasTapped(_ sender: Any) {
        guard let storyboard = storyboard else {
            fatalError()
        }
        let addLocationViewController = storyboard.instantiateViewController(withIdentifier: "AddLocationViewController")
        present(addLocationViewController, animated: true, completion: nil)
    }
}
