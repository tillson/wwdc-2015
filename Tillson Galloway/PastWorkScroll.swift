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
    @IBOutlet var signedInTechImageView: AnimatableImageView!
    
    var delegate: PastWorkDelegate?
    
    override func awakeFromNib() {
        timedTestImage.layer.cornerRadius = 10.0
        timedTestImage.clipsToBounds = true
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.signedInTechImageView.animateWithImage(named: "signedintech.gif")
        }
        
    }

    @IBAction func signedInButton(sender: AnyObject) {
        delegate?.shouldScrollToPosition(675)
    }
    
    @IBAction func timedButton(sender: AnyObject) {
        delegate?.shouldScrollToPosition(1350)
    }
    
    @IBAction func openSourceButton(sender: AnyObject) {
        delegate?.shouldScrollToPosition(2025)
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        delegate?.backButtonPressed()
    }
    
    @IBAction func demoButtonPressed(sender: AnyObject) {
        delegate?.startTimedTestDemo()
    }
    
}
