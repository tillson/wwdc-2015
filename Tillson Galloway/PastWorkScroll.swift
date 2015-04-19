//
//  PassWorkScroll.swift
//  Tillson Galloway
//
//  Created by Tillson on 4/17/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit

class PastWorkScroll: UIView {
   
    @IBOutlet var timedTestImage: UIImageView!
    @IBOutlet var signedInView: UIView!
    
    var scrollView: UIScrollView?
    
    override func awakeFromNib() {
        timedTestImage.layer.cornerRadius = 10.0
        timedTestImage.clipsToBounds = true
    }

    @IBAction func signedInButton(sender: AnyObject) {
        if let scrollV = scrollView {
            scrollV.setContentOffset(CGPoint(x: 0, y: 675), animated: true)
        }
    }
    
    @IBAction func timedButton(sender: AnyObject) {
        if let scrollV = scrollView {
            scrollV.setContentOffset(CGPoint(x: 0, y: 1350), animated: true)
        }
    }
    
    @IBAction func openSourceButton(sender: AnyObject) {
        if let scrollV = scrollView {
            scrollV.setContentOffset(CGPoint(x: 0, y: 2025), animated: true)
        }
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.5, animations: {
            self.scrollView!.alpha = 0.0
            }, completion: { completed in
                self.scrollView!.alpha = 1.0
                self.scrollView!.removeFromSuperview()
        })
    }
    
    func startSignedInAnimation() {
        let grayCircle = UIView()
        grayCircle.frame = CGRect(x: 0, y: 100, width: 30, height: 30)
        grayCircle.backgroundColor = UIColor.grayColor()
        grayCircle.layer.cornerRadius = 15.0
        signedInView.insertSubview(grayCircle, atIndex: 0)
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 40, y: 50))
        path.addCurveToPoint(CGPoint(x: 150, y: 110), controlPoint1: CGPoint(x: 100, y: 5), controlPoint2: CGPoint(x: 120, y: 5))

        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.CGPath
        animation.repeatCount = Float.infinity
        animation.duration = 1.75
        animation.calculationMode = kCAAnimationPaced
        grayCircle.layer.addAnimation(animation, forKey: "animate position along path")
        
        
        let phoneGreenCircle = UIView()
        phoneGreenCircle.frame = CGRect(x: 0, y: 100, width: 30, height: 30)
        phoneGreenCircle.backgroundColor = UIColor.greenColor()
        phoneGreenCircle.layer.cornerRadius = 15.0
        signedInView.insertSubview(phoneGreenCircle, atIndex: 0)
        
        let phonePath = UIBezierPath()
        phonePath.moveToPoint(CGPoint(x: 150, y: 110))
        phonePath.addCurveToPoint(CGPoint(x: 40, y: 50), controlPoint1: CGPoint(x: 120, y: 5), controlPoint2: CGPoint(x: 100, y: 5))
        
        let phoneAnimation = CAKeyframeAnimation(keyPath: "position")
        phoneAnimation.path = phonePath.CGPath
        phoneAnimation.repeatCount = Float.infinity
        phoneAnimation.duration = 1.75
        phoneAnimation.calculationMode = kCAAnimationPaced
        
        phoneGreenCircle.layer.addAnimation(phoneAnimation, forKey: "animate phone ball on path")
        
        let computerGreenCircle = UIView()
        computerGreenCircle.frame = CGRect(x: 0, y: 100, width: 30, height: 30)
        computerGreenCircle.backgroundColor = UIColor.greenColor()
        computerGreenCircle.layer.cornerRadius = 15.0
        signedInView.insertSubview(computerGreenCircle, atIndex: 0)
        
        let computerPath = UIBezierPath()
        computerPath.moveToPoint(CGPoint(x: 150, y: 110))
        computerPath.addCurveToPoint(CGPoint(x: 300, y: 110), controlPoint1: CGPoint(x: 200, y: 5), controlPoint2: CGPoint(x: 220, y: 5))
        
        let cpuAnimation = CAKeyframeAnimation(keyPath: "position")
        cpuAnimation.path = computerPath.CGPath
        cpuAnimation.repeatCount = Float.infinity
        cpuAnimation.duration = 1.75
        cpuAnimation.calculationMode = kCAAnimationPaced

        computerGreenCircle.layer.addAnimation(cpuAnimation, forKey: "animate computer ball on path")
        
    }
}
