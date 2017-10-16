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
        guard let parent = parent else { return }
        GUI.initializeMainController(parent)
    }

    @IBAction func logOutWasTapped(_ sender: Any) {
    }
    
    
    @IBAction func reloadWasTapped(_ sender: UIBarButtonItem) {
        guard let parent = parent  else {
            return
        }
        GUI.showOverlaySpinner(on: parent.view)
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
