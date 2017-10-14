//
//  MaterialActivityIndicatorOverlay.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 14/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class MaterialActivityIndicatorOverlay: UIView {
    
    private var materialSpinner: MaterialSpinner?
    private var colors: [UIColor]
    
    convenience init() {
        self.init(strokeColors: [UIColor.blue])
    }
    
    init(strokeColors: [UIColor]) {
        colors = strokeColors
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        colors = [UIColor.blue]
        materialSpinner = MaterialSpinner(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
        super.init(coder: aDecoder)
        setup()
    }

    
    private func setup() {
        backgroundColor = UIColor(white: 0.0, alpha: 0.6)
    }
    
    func startSpinning() {
        materialSpinner?.removeFromSuperview()
        materialSpinner = MaterialSpinner(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)), strokeColors: colors)
        addSubview(materialSpinner!)
        materialSpinner!.center = center
        materialSpinner!.startSpinning()
    }

}
