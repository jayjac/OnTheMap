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
    private var xConstraint: NSLayoutConstraint!
    private var yConstraint: NSLayoutConstraint!
    
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
        //centerSpinner()
        guard let superView = superview, let materialSpinner = materialSpinner else { return }
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superView, attribute: .left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        //self.removeConstraints(self.constraints)
        superView.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        materialSpinner.startSpinning()
    }
    


}
