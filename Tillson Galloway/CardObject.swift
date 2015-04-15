//
//  CardObject.swift
//  FileCabinet
//
//  Created by Tillson on 4/14/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit

class CardObject {

    let title: String
    let body: String
    
    var customView: UIView?

    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
    
    
}
