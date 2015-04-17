//
//  PassCard.swift
//  FileCabinet
//
//  Created by Tillson on 3/31/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit

class PassCard: UICollectionViewCell {

    @IBOutlet var cardTitle: UILabel!
    @IBOutlet var cardBody: UITextView!
    @IBOutlet var cardBackground: UIImageView!
    var customView: UIView?
        {
        didSet {
            self.addSubview(customView!)
        }
    }
    
    // Eventually will have gradient support
//    func setBackgroundColor(color: UIColor) {
//        backgroundColor = color
//    }
    
    override func awakeFromNib() {
        
        
        
        cardBackground.layer.shadowColor = UIColor.blackColor().CGColor
        cardBackground.layer.shadowOffset = CGSize(width: 0, height: -1)
        cardBackground.layer.shadowOpacity = 0.6
        cardBackground.layer.shadowRadius = 3.0
        cardBackground.clipsToBounds = false
    }
    
}
