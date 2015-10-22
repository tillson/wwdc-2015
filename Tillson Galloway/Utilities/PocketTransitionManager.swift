//
//  PocketTransitionManager.swift
//  Tillson Galloway
//
//  Created by Tillson on 4/26/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit

import UIKit

class PocketTransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        container!.addSubview(toView)
        container!.addSubview(fromView)
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateKeyframesWithDuration(1.0, delay: 0.0, options: [], animations: {
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: {
                toView.frame.size = CGSize(width: toView.frame.size.width / 2, height: toView.frame.size.height / 2)
            })
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: {
                toView.frame.origin.y = fromView.frame.height
            })
            }, completion: { completed in
                toView.removeFromSuperview()
                fromView.removeFromSuperview()
        })
        
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
}