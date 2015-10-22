//
//  TransitionManager.swift
//  Tillson Galloway
//
//  Created by Tillson on 4/14/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit

class OpeningTransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!

        container!.addSubview(toView)
        container!.addSubview(fromView)
        
        let duration = self.transitionDuration(transitionContext)

        let imageBall = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ViewController).imageBall
        imageBall.removeFromSuperview()

        let image = fromView.getImage().CGImage
        let topImageRef = CGImageCreateWithImageInRect(image, CGRect(x: 0, y: 0, width: fromView.frame.width * 2, height: fromView.frame.height))
        let bottomImageRef = CGImageCreateWithImageInRect(image, CGRect(x: 0, y: fromView.frame.height, width: fromView.frame.width * 2, height: fromView.frame.height))
        
        let topImageView = UIImageView(image: UIImage(CGImage: topImageRef!))
        let bottomImageView = UIImageView(image: UIImage(CGImage: bottomImageRef!))
        topImageView.frame.origin.x = 0
        topImageView.frame.origin.y = 0
        topImageView.frame.size.height = fromView.frame.height / 2
        topImageView.frame.size.width = fromView.frame.width

        bottomImageView.frame.origin.x = 0
        bottomImageView.frame.origin.y = container!.frame.height / 2
        bottomImageView.frame.size.height = fromView.frame.height / 2
        bottomImageView.frame.size.width = fromView.frame.width
        
        container!.addSubview(topImageView)
        imageBall.frame.origin.y = fromView.frame.height / 2 - imageBall.frame.height / 2
        container!.addSubview(bottomImageView)
        container!.addSubview(imageBall)

        fromView.removeFromSuperview()
        
        UIView.animateWithDuration(duration, delay: 0.0, options: [], animations: {
            topImageView.frame.origin.y = -container!.frame.height / 2 - 80
            imageBall.frame.origin.y = -bottomImageView.frame.height / 4 - 80
            bottomImageView.frame.origin.y = container!.frame.height + 80
            }, completion: { completion in
                transitionContext.completeTransition(true)
                topImageView.removeFromSuperview()
                bottomImageView.removeFromSuperview()
                imageBall.removeFromSuperview()
                fromView.removeFromSuperview()
        })
        
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
}