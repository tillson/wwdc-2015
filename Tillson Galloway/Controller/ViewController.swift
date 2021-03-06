//
//  ViewController.swift
//  Tillson Galloway
//
//  Created by Tillson on 4/14/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var hiLabel: UILabel!
    @IBOutlet var buttonShimmerView: FBShimmeringView!
    @IBOutlet var myNameLabel: UILabel!
    
    let leftLine = CAShapeLayer()
    let rightLine = CAShapeLayer()
    let circle = CAShapeLayer()
    
    let imageBall = UIImageView()
    
    let dynamicView = UIView()
    var animator: UIDynamicAnimator!
    let transitionManager = OpeningTransitionManager()
    
    let emitter = CAEmitterCell()
    let emitterLayer = CAEmitterLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self
        
        myNameLabel.alpha = 0.0
        
        buttonShimmerView.alpha = 0
        buttonShimmerView.contentView = buttonShimmerView.subviews[0] as! UIView
        buttonShimmerView.shimmering = true
        buttonShimmerView.shimmeringSpeed = 60
        buttonShimmerView.shimmeringPauseDuration = 0.01
        
        animator = UIDynamicAnimator(referenceView: dynamicView)
        
        hiLabel.frame.origin.y = view.frame.width - 40
        hiLabel.alpha = 0
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.hiLabel.alpha = 1
                self.hiLabel.frame.origin.y = 8
            
            }, completion: { completed in
                self.animateImage()
        })
        
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.animateBubbles()
            UIView.animateWithDuration(0.25, animations: {
                self.buttonShimmerView.alpha = 1.0
                self.myNameLabel.alpha = 1.0
            })
        }
    }
    
    func animateBubbles() {
        emitterLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2 + 80)
        emitterLayer.emitterPosition = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 - 20)
        emitterLayer.emitterSize = CGSize(width: 100, height: 47)
        
        emitter.birthRate = 5
        emitter.lifetime = 2.5
        emitter.alphaRange = 0.2
        emitter.alphaSpeed = -0.7
        emitter.scale = 0.2
        emitter.scaleSpeed = 0.45
        emitter.yAcceleration = -100
        emitter.velocity = 10
        emitter.velocityRange = 150
        emitter.emissionRange = CGFloat(M_PI_2)
        emitter.name = "cell"
        emitter.color = UIColor.blueColor().CGColor //UIColor(hue: CGFloat(drand48()), saturation: 1.0, brightness: 1.0, alpha: 0.5).CGColor
        emitter.contents = UIImage(named: "circle")!.CGImage
        
        emitter.redRange = 5.0
        emitter.blueRange = 1.0
        emitter.greenRange = 1.0

        emitterLayer.emitterCells = [self.emitter]
        
        self.view.layer.insertSublayer(emitterLayer, atIndex: 0)
    }
    
    override func viewDidDisappear(animated: Bool) {
        emitterLayer.removeAllAnimations()
        emitterLayer.removeFromSuperlayer()
    }
    
    func animateImage() {
        drawCircle()
        
        setupShape(leftLine, xStart: 0, xMiddleOffset: -80, animationKey: "leftAnimation")
        setupShape(rightLine, xStart: view.frame.width, xMiddleOffset: 80, animationKey: "rightAnimation")
        
        dynamicView.frame = CGRect(x: 0, y: -view.frame.height*0.5 + 80, width: view.frame.width, height: view.frame.height)
        view.addSubview(dynamicView)

        imageBall.frame = CGRect(x: dynamicView.frame.width / 2 - 80, y: 0, width: 160, height: 160)
        imageBall.image = UIImage(named: "me") // #photogenic
        imageBall.layer.cornerRadius = 80.0
        imageBall.clipsToBounds = true
        dynamicView.addSubview(imageBall)
        let gravity = UIGravityBehavior(items: [imageBall])
        let collision = UICollisionBehavior(items: [imageBall])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
    }

    @IBAction func buttonPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.5, animations: {
            self.imageBall.transform = CGAffineTransformMakeRotation(-90 * 0.0174532925)
            }, completion: { completed in
                let semi = CAShapeLayer()
                semi.frame = CGRect(x: self.view.frame.width / 2 - 80, y: self.view.frame.height / 2 - 80 , width: 160, height: 160)
                semi.lineWidth = 1
                semi.fillColor = UIColor.clearColor().CGColor
                semi.strokeColor = UIColor.darkGrayColor().CGColor
                semi.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 160, height: 160), cornerRadius: 80).CGPath
                semi.strokeEnd = 0.5
                self.view.layer.addSublayer(semi)
                semi.transform = CATransform3DMakeRotation(90 * 0.0174532925, 0.0, 0.0, 1.0);
                
                self.performSegueWithIdentifier("cabinetSegue", sender: sender)
        })
    }
    
    // MARK: "fun" CoreAnimation util stuff
    
    func setupShape(shape: CAShapeLayer, xStart: CGFloat, xMiddleOffset: CGFloat, animationKey: String) {
        shape.frame = CGRect(x: 0, y: view.frame.height / 2, width: view.frame.width, height: 1)
        shape.lineWidth = 2
        shape.fillColor = UIColor.darkGrayColor().CGColor
        shape.strokeColor = UIColor.darkGrayColor().CGColor
        shape.path = getPath(xStart, distanceFromMiddleEnd: xMiddleOffset)
        view.layer.addSublayer(shape)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.6
        animation.beginTime = CACurrentMediaTime()
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        shape.addAnimation(animation, forKey: animationKey)
    }
    
    func drawCircle() {
        let semi = CAShapeLayer()
        semi.frame = CGRect(x: view.frame.width / 2 - 80, y: view.frame.height / 2 - 80 , width: 160, height: 160)
        semi.lineWidth = 2
        semi.fillColor = UIColor.clearColor().CGColor
        semi.strokeColor = UIColor.darkGrayColor().CGColor
        semi.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 160, height: 160), cornerRadius: 80).CGPath
        semi.strokeEnd = 0.0
        view.layer.addSublayer(semi)
        semi.transform = CATransform3DMakeRotation(90 * 0.0174532925, 0.0, 0.0, 1.0);
        
        let circleAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circleAnimation.duration = 0.3
        circleAnimation.beginTime = CACurrentMediaTime() + 0.4
        circleAnimation.fromValue = 0.0
        circleAnimation.toValue = 0.5
        circleAnimation.fillMode = kCAFillModeForwards
        circleAnimation.removedOnCompletion = false
        semi.addAnimation(circleAnimation, forKey: "circle1")
        
        let finishAnimation = CABasicAnimation(keyPath: "strokeEnd")
        finishAnimation.duration = 0.3
        finishAnimation.beginTime = CACurrentMediaTime() + 1.5
        finishAnimation.fromValue = 0.5
        finishAnimation.toValue = 1.0
        finishAnimation.fillMode = kCAFillModeForwards
        finishAnimation.removedOnCompletion = false
        semi.addAnimation(finishAnimation, forKey: "circle2")

    }
    
    func getPath(xStart: CGFloat, distanceFromMiddleEnd: CGFloat) -> CGPathRef {
        let path = UIBezierPath()
        let w = leftLine.bounds.size.width
        path.moveToPoint(CGPointMake(xStart, 0))
        path.addLineToPoint(CGPointMake(w / 2 + distanceFromMiddleEnd, 0))
        path.closePath()

        return path.CGPath
    }
}

extension ViewController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionManager
    }
}
