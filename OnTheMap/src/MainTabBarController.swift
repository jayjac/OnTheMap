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
    @IBOutlet weak var logoutBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .custom)
        let image = UIImage(named: "icon_refresh")
        //button.setBackgroundImage(image, for: .normal)
        button.setImage(image, for: .normal)
        button.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 50))
        reloadBarButton.customView = button
        reloadBarButton.isEnabled = true

    }

    @IBAction func reloadWasTapped(_ sender: UIBarButtonItem) {
        print("reload tapped")
    }

}
