//
//  PastWorkViewController.swift
//  Tillson Galloway
//
//  Created by Tillson on 4/19/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit

class PastWorkViewController: UIViewController {

    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = view.frame
        view.addSubview(scrollView)
        let array = NSBundle.mainBundle().loadNibNamed("PastWorkScroll", owner: self, options: nil)
        let pastWorkView = array[0] as! PastWorkScroll
        scrollView.contentSize = pastWorkView.frame.size
        pastWorkView.delegate = self
        scrollView.addSubview(pastWorkView)
        
        view.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PastWorkViewController: PastWorkDelegate {
    
    func shouldScrollToPosition(y: Int) {
        scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
    }
    
    func backButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func startTimedTestDemo() {
        self.presentViewController(TimedTestViewController(), animated: true, completion: nil)
    }
    
}