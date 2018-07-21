//
//  SlowlyShowTransition.swift
//  YQKit
//
//  Created by sungrow on 2018/7/21.
//  Copyright © 2018年 sungrow. All rights reserved.
//

import UIKit

class SlowlyShowTransition: NSObject {

}

extension SlowlyShowTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension SlowlyShowTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        if fromVC?.isBeingDismissed ?? false {
            animationForDismissedView(transitionContext)
        }
        let toVC = transitionContext.viewController(forKey: .to)
        if toVC?.isBeingPresented ?? false {
            animationForPresentedView(transitionContext)
        }
    }
    
    func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning) {
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        transitionContext.containerView.addSubview(presentedView!)
        presentedView?.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            presentedView?.alpha = 1.0
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
    func animationForDismissedView(_ transitionContext: UIViewControllerContextTransitioning) {
        let dismissView = transitionContext.view(forKey: .from)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissView?.alpha = 0
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
