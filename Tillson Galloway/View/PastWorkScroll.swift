//
//  PassWorkScroll.swift
//  Tillson Galloway
//
//  Created by Tillson on 4/17/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit

class PastWorkScroll: UIView {
   
    @IBOutlet var signedInImage: UIImageView!
    @IBOutlet var timedTestImage: UIImageView!
    @IBOutlet var openSourceImage: UIImageView!

    @IBOutlet var signedInTechImageView: UIImageView!
    
    @IBOutlet var commitNumbers: UILabel!
    
    var delegate: PastWorkDelegate?
    
    override func awakeFromNib() {
        timedTestImage.layer.cornerRadius = 10.0
        timedTestImage.clipsToBounds = true
        
        let signedTapGesture = UITapGestureRecognizer()
        signedTapGesture.numberOfTapsRequired = 1
        signedTapGesture.addTarget(self, action: "signedInButton:")
        signedInImage.addGestureRecognizer(signedTapGesture)
        
        let testTapGesture = UITapGestureRecognizer()
        testTapGesture.numberOfTapsRequired = 1
        testTapGesture.addTarget(self, action: "timedButton:")
        timedTestImage.addGestureRecognizer(testTapGesture)

        let gitTapGesture = UITapGestureRecognizer()
        gitTapGesture.numberOfTapsRequired = 1
        gitTapGesture.addTarget(self, action: "openSourceButton:")
        openSourceImage.addGestureRecognizer(gitTapGesture)

        
//        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
//        dispatch_async(dispatch_get_global_queue(priority, 0)) {
//            self.signedInTechImageView.animateWithImage(named: "signedintech.gif")
//        }
        
        
        let url = NSURL(string: "http://tillsongalloway.com/api/GithubCommits.php?git")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let num = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            dispatch_async(dispatch_get_main_queue(), {
                self.commitNumbers.text = num
            })
        }
        
        task.resume()
        
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
