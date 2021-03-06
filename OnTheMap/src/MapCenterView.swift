//
//  MapCenterView.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 07/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//


import UIKit

@IBDesignable
class MapCenterView: UIView {
    
    //@IBOutlet weak var label: UILabel!
    private let pathLayer = CAShapeLayer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        self.layer.insertSublayer(pathLayer, at: 0 as UInt32)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        self.layer.insertSublayer(pathLayer, at: 0 as UInt32)
    }
    


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        backgroundColor = UIColor.clear
        let ARROW_HEIGHT: CGFloat = 10.0
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height - ARROW_HEIGHT))
        path.addLine(to: CGPoint(x: frame.width / 2 + 10, y: frame.height - ARROW_HEIGHT))
        path.addLine(to: CGPoint(x: frame.width / 2, y: frame.height))
        path.addLine(to: CGPoint(x: frame.width / 2 - 10, y: frame.height - ARROW_HEIGHT))
        path.addLine(to: CGPoint(x: 0, y: frame.height - ARROW_HEIGHT))
        path.close()
        pathLayer.path = path.cgPath
        pathLayer.backgroundColor = UIColor.clear.cgColor
        pathLayer.fillColor = UIColor.blue.cgColor
        pathLayer.frame = self.layer.bounds

    }
 

}
