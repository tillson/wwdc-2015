//
//  PastWorkDelegate.swift
//  Tillson Galloway
//
//  Created by Tillson on 4/19/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit

protocol PastWorkDelegate {
   
    func shouldScrollToPosition(y: Int)
    func backButtonPressed()
    
    func startTimedTestDemo()

}
