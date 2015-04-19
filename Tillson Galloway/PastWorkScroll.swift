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
        
        let grayCircle = UIView()
        grayCircle.frame = CGRect(x: 33, y: 1100, width: 30, height: 30)
        grayCircle.backgroundColor = UIColor.grayColor()
        grayCircle.layer.cornerRadius = 15.0
        addSubview(grayCircle)
        
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
}
