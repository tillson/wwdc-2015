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
    let imageName: String
    
    var attributedBody: NSAttributedString?
    var moreInfoViewController: UIViewController.Type?

    init(title: String, body: String, imageName: String, attributedBody: NSAttributedString? = nil) {
        self.title = title
        self.body = body
        self.imageName = imageName
        if let attributed = attributedBody {
            self.attributedBody = attributedBody
        }
    }
    
    
}
