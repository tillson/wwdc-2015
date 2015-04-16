//
//  PushNoAnimationSegue.swift
//  iSignedIn
//
//  Created by Tillson on 1/7/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit

class PushNoAnimationSegue: UIStoryboardSegue {
    
    override func perform() {
        sourceViewController.navigationController?!.pushViewController(destinationViewController as! UIViewController, animated: false)
    }
}