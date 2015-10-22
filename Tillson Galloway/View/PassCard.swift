//
//  PassCard.swift
//  Tillson Galloway
//
//  Created by Tillson on 4/15/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit
import MapKit

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
            if cardObject.title == "Timeline" {
                self.seeMoreButton.setTitle("Play", forState: UIControlState.Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        seeMoreButton.alpha = 0.0
        
        cardBackground.layer.shadowColor = UIColor.blackColor().CGColor
        cardBackground.layer.shadowOffset = CGSize(width: 0, height: -1)
        cardBackground.layer.shadowOpacity = 0.6
        cardBackground.layer.shadowRadius = 3.0
        cardBackground.clipsToBounds = false
        
        cardBody.delegate = self
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

extension PassCard: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
//        let string = URL.absoluteString.substringFromIndex(6) as String
//        
//        if string == "PorterGaudSchool" {
//            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 32.7740403, longitude: -79.9644841), span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)) // james bond
//            delegate?.openMapForRegion(region, title: "Porter-Gaud School")
//        } else if string == "TheCollegeofCharleston" {
//            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 32.7837209, longitude: -79.9373006), span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007))
//            delegate?.openMapForRegion(region, title: "College of Charleston Campus")
//        } else {
//            println(string)
//        }
        return false
    }
    
}
