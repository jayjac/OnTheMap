//
//  FadeInAnimator.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 14/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import UIKit

class FadeInAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5
    private let presenting: Bool
    
    init(presenting: Bool = true) {
        self.presenting = presenting
        super.init()
    }

    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if presenting {
            guard let toView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
            }
            containerView.addSubview(toView)
            toView.frame = containerView.bounds
            toView.alpha = 0.0
            UIView.animate(withDuration: duration, animations: {
                toView.alpha = 1.0
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else {
            guard let fromView = transitionContext.view(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
            }
            UIView.animate(withDuration: duration, animations: { 
                fromView.alpha = 0.0
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }

        
    }
}


class FadeInTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FadeInAnimator(presenting: false)
    }
    
    
}
