//
//  MainNavigationViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 12/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit


enum NavBarState {
    case show
    case interactiveHidden
}

class MainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func setBar(to state: NavBarState) {
        let flag: Bool
        switch state {
        case .show:
            flag = true
  
        case .interactiveHidden:
            flag = false

        }
        
        self.hidesBarsOnTap = flag
        self.hidesBarsOnSwipe = flag
        self.hidesBarsWhenKeyboardAppears = flag
    }


}
