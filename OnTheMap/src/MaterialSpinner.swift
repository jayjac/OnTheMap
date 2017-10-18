//
//  MaterialSpinner.swift
//  MaterialSpinner
//
//  Created by Jean-Yves Jacaria on 20/06/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit



class MaterialSpinner: UIView, CAAnimationDelegate {
    
    private let subLayer = CAShapeLayer()
    private var currentStrokeColorIndex = 0
    
    private let totalNumberOfCircleDivisions = 7
    private var currentDivisionInCircle = 0
    private var circleOffset: CGFloat {
        return CGFloat(currentDivisionInCircle) / CGFloat(totalNumberOfCircleDivisions)
    }
    private let stretchingDuration: CFTimeInterval = 0.6
    private let rotationDuration: CFTimeInterval = 2.3
    
    private var strokeColors: [UIColor]?
    @IBInspectable var strokeColor: UIColor {
        didSet {
            subLayer.strokeColor = strokeColor.cgColor
        }
    }
    @IBInspectable var lineWidth: CGFloat
    @IBInspectable var isInteractive: Bool = false
    private var shouldStopAllAnimations: Bool = false
    
    
    //MARK:- Initializers
    convenience override init(frame: CGRect) {
        self.init(frame: frame, strokeColors: [UIColor.black], lineWidth: 2.0)
    }
    
    
    convenience init(frame: CGRect, strokeColor: UIColor, lineWidth: CGFloat = 2.0, interactive: Bool = false) {
        self.init(frame: frame, strokeColors: [strokeColor], lineWidth: lineWidth)
    }
    
    
    init(frame: CGRect, strokeColors: [UIColor], lineWidth: CGFloat = 2.0, interactive: Bool = false) {
        self.strokeColors = strokeColors
        self.strokeColor = strokeColors.first! //purposefully crash the app if there's no color in there
        self.lineWidth = lineWidth
        isInteractive = interactive
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        self.strokeColor = UIColor.black
        self.lineWidth = 2.0
        super.init(coder: aDecoder)
    }
    //MARK:-
    
    override func awakeFromNib() {
        setup()
    }
    
    func setStrokeColors(_ colors: [UIColor]) {
        self.strokeColors = colors
        self.strokeColor = colors.first!
    }
    
    
    private func setup() {
        backgroundColor = UIColor.clear
        self.layer.addSublayer(subLayer)
        subLayer.frame = layer.bounds
        subLayer.strokeColor = strokeColor.cgColor
        subLayer.fillColor = UIColor.clear.cgColor
        subLayer.lineWidth = self.lineWidth
        adaptCircleToCurrentOffset()
    }
    
    func startSpinning() {
        resetCircle()
        animate()
        constantRotation()
    }
    
    private func resetCircle() {
        currentDivisionInCircle = 0
        currentStrokeColorIndex = 0
        subLayer.transform = CATransform3DIdentity
        adaptCircleToCurrentOffset(true)
    }
    
    private func adaptCircleToCurrentOffset(_ initiallyNil: Bool = false) {
        let rect = layer.bounds
        let minSide = min(rect.width, rect.height) // the spinner will be located within a square of side minSide
        let center = CGPoint(x: minSide / 2, y: minSide / 2)
        let radius = minSide / 2 - lineWidth
        let relativePoint = 2 * CGFloat.pi * circleOffset // needed in start/endAngle. Save it here in order to not calculate it twice
        let startAngle = -CGFloat.pi / 2 + relativePoint
        let endAngle = -CGFloat.pi / 2 + relativePoint + 2 * CGFloat.pi
        let fullCircle = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // Below I wrap things inside a transaction to disable the strokes' default initial  animation because when isInteractive is true, the first extension is not clear (strokeEnd and strokeStart are animated by default)
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        subLayer.strokeStart = 0
        subLayer.strokeEnd = initiallyNil ? 0.0 : 1.0 / CGFloat(totalNumberOfCircleDivisions)
        CATransaction.commit()
        
        subLayer.path = fullCircle.cgPath
        guard let strokeColors = strokeColors, strokeColors.count > 1 else {return}
        
        strokeColor = strokeColors[currentStrokeColorIndex] // this will update the path color automatically
        currentStrokeColorIndex += 1
        currentStrokeColorIndex %= strokeColors.count
    }
    

    
    private func animate() {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.beginTime = CACurrentMediaTime() + 0.1
        animation.toValue = CGFloat(totalNumberOfCircleDivisions - 1) / CGFloat(totalNumberOfCircleDivisions)
        animation.duration = stretchingDuration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeBoth
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        subLayer.add(animation, forKey: "expanding")
        
        animation.keyPath = "strokeStart"
        animation.toValue = CGFloat(totalNumberOfCircleDivisions - 2) / CGFloat(totalNumberOfCircleDivisions)
        animation.beginTime = CACurrentMediaTime() + stretchingDuration + 0.2
        
        animation.delegate = self
        subLayer.add(animation, forKey: "retracting")
        
    }
    
    private func constantRotation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = rotationDuration
        animation.fillMode = kCAFillModeBoth
        animation.toValue = CGFloat.pi * 2
        animation.isRemovedOnCompletion = false
        animation.repeatCount = .infinity
        subLayer.add(animation, forKey: "constantRotation")
    }
    
    
    func stopAllAnimations() {
        shouldStopAllAnimations = true
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // the startStroke will move forward by the number of circleDivisions minus 2 (minus 1 for the endStroke)
        currentDivisionInCircle += (totalNumberOfCircleDivisions - 2)
        
        // if the number is greater than the possible amount of divisions, I take the modulo
        currentDivisionInCircle %= totalNumberOfCircleDivisions
        
        if shouldStopAllAnimations {
            resetCircle()
            subLayer.removeAllAnimations()
            return
        }
        
        adaptCircleToCurrentOffset()
        subLayer.removeAnimation(forKey: "initialRetracting")
        subLayer.removeAnimation(forKey: "expanding")
        subLayer.removeAnimation(forKey: "retracting")
        animate()
    }
    
}
