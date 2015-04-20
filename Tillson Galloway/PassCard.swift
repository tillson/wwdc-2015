//
//  PassCard.swift
//  FileCabinet
//
//  Created by Tillson on 4/15/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit

class PassCard: UICollectionViewCell {

    @IBOutlet var cardTitle: UILabel!
    @IBOutlet var cardBody: UITextView!
    @IBOutlet var cardBackground: UIImageView!
    @IBOutlet var seeMoreButton: UIButton!
    
    var cardObject: CardObject!
    var delegate: CabinetDelegate?
    
    var showSeeMoreButton = false
        {
        didSet {
            self.seeMoreButton.alpha = showSeeMoreButton ? 1.0 : 0.0
        }
    }
    
    // Eventually will have gradient support(?)
//    func setBackgroundColor(color: UIColor) {
//        backgroundColor = color
//    }
    
    override func awakeFromNib() {
        seeMoreButton.alpha = 0.0
        
        cardBackground.layer.shadowColor = UIColor.blackColor().CGColor
        cardBackground.layer.shadowOffset = CGSize(width: 0, height: -1)
        cardBackground.layer.shadowOpacity = 0.6
        cardBackground.layer.shadowRadius = 3.0
        cardBackground.clipsToBounds = false
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        seeMoreButton.enabled = false
        
        delegate?.moreInfoButtonPressed(cardObject)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.seeMoreButton.enabled = true
        }
    }
}
