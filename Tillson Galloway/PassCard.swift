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
    
    var customView: UIView?
        {
        didSet {
            self.seeMoreButton.alpha = 1.0
        }
    }
    
    // Eventually will have gradient support
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
        if let cView = customView {
            cView.alpha = 1.0
            superview?.addSubview(cView)
            cView.frame = CGRect(x: 0, y: 0, width: 0.0, height: 0.0)
            UIView.animateWithDuration(0.5, animations: {
                cView.frame.size = self.superview!.frame.size
            })
        }
    }
}
