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
    }

    @IBAction func logOutWasTapped(_ sender: Any) {
    }
    
    
    @IBAction func reloadWasTapped(_ sender: UIBarButtonItem) {
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
