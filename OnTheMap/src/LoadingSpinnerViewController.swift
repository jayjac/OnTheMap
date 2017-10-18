//
//  LoadingSpinnerViewController.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 18/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class LoadingSpinnerViewController: UIViewController {

    
    @IBOutlet weak var spinner: MaterialSpinner!
    private var colors: [UIColor]?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spinner.startSpinning()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let colors = colors else { return }
        spinner.setStrokeColors(colors)
    }
    
    func setStrokeColors(_ colors: [UIColor]) {
        self.colors = colors
    }
    

    

}
