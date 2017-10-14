//
//  RetrieveUserInfoViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 14/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class RetrieveUserInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func retrieveUserInfo(_ sender: Any) {
        SessionManager.default.retrieveUserInfo()
    }

}
