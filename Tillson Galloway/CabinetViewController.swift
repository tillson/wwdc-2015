//
//  CabinetViewController.swift
//  Tillson Galloway
//
//  Created by Tillson on 4/14/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit
import MapKit

class CabinetViewController: UICollectionViewController {
    
    var cards = [CardObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = nil
        
        cards.append(CardObject(title: "", body: "", imageName: ""))
        
        cards.append(CardObject(title: "About Me", body: "", imageName: "card-red", attributedBody: getBioText()))

        let pastWork = CardObject(title: "Past Work", body: "In the past, I've worked on a vareity of apps, including: iSignedIn, Timed Test, and a vareity of open source projects at my school.", imageName: "card-orange")
        pastWork.moreInfoViewController = PastWorkViewController.self
        cards.append(pastWork)
        
        cards.append(CardObject(title: "Technical Skills", body: "none ;(", imageName: "card-green"))
        
        let timeline = CardObject(title: "Timeline", body: "A game", imageName: "card-blue")
        timeline.moreInfoViewController = GameViewController.self
        cards.append(timeline)
        
        collectionView?.registerNib(UINib(nibName: "PassCard", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "pass")
    }

    func getBioText() -> NSAttributedString {
        let path = NSBundle.mainBundle().pathForResource("bio", ofType: "txt")!
        let data = NSData(contentsOfFile: path)
        var originalString = NSString(data: data!, encoding: NSASCIIStringEncoding) as! String
        var attributedString = NSMutableAttributedString(string: originalString)

        let textRange = NSMakeRange(0, attributedString.length)
        let regex = NSRegularExpression(pattern: "\\{(.*?)\\}", options: nil, error: nil)!
        
        let matches = regex.matchesInString(originalString, options: NSMatchingOptions.WithoutAnchoringBounds, range: textRange)
        attributedString.addAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], range: textRange)

        for match in matches as! [NSTextCheckingResult] {
            let matchRange = match.range
            var text = (originalString as NSString).substringWithRange(match.range)
            text = text.stringByReplacingOccurrencesOfString("{", withString: "").stringByReplacingOccurrencesOfString("}", withString: "").stringByReplacingOccurrencesOfString("-", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
            attributedString.beginEditing()
            attributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "http://\(text)")!, range: matchRange)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: matchRange)
            attributedString.endEditing()
        }
        
        return attributedString
    }
    
    
    // MARK: Collection View Stuff
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            return collectionView.dequeueReusableCellWithReuseIdentifier("header", forIndexPath: indexPath) as! UICollectionViewCell
        }
        
        let card: PassCard = collectionView.dequeueReusableCellWithReuseIdentifier("pass", forIndexPath: indexPath) as! PassCard
        card.cardTitle.text = cards[indexPath.row].title
        card.cardBody.text = cards[indexPath.row].body
        if let attributed = cards[indexPath.row].attributedBody {
            card.cardBody.attributedText = attributed
        }
        card.cardBackground.image = UIImage(named: cards[indexPath.row].imageName)
        card.cardObject = cards[indexPath.row]
        card.delegate = self
        if let moreVC: AnyClass = cards[indexPath.row].moreInfoViewController {
            card.showSeeMoreButton = true
        }
        return card
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.item == 0 {
            return false
        }
        var select = true
        for path in collectionView.indexPathsForSelectedItems() {
            collectionView.deselectItemAtIndexPath((path as! NSIndexPath), animated: true)
            collectionView.delegate?.collectionView!(collectionView, didDeselectItemAtIndexPath: indexPath)
            select = false
        }
        return select
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.performBatchUpdates(nil, completion: nil)
        collectionView.scrollEnabled = true
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.performBatchUpdates(nil, completion: nil)
        collectionView.scrollEnabled = false
    }
    
}

extension CabinetViewController: CabinetDelegate {
    
    func moreInfoButtonPressed(card: CardObject) {
        if let moreVC: UIViewController.Type = card.moreInfoViewController {
            self.presentViewController(moreVC(), animated: true, completion: nil)
        }
    }
    
    func openMapForRegion(region: MKCoordinateRegion) {
        let popupView = UIView()
        popupView.frame = view.frame
        popupView.backgroundColor = UIColor.blackColor()
        popupView.alpha = 0.0
        view.addSubview(popupView)
        
        let mapView = MKMapView()
        mapView.mapType = .Hybrid
        mapView.setRegion(region, animated: false)
        view.addSubview(mapView)
        mapView.layer.borderColor = UIColor.whiteColor().CGColor
        mapView.layer.borderWidth = 2.0
        
        UIView.animateWithDuration(0.25, animations: {
            popupView.alpha = 0.3
            mapView.alpha = 1.0
            mapView.frame = CGRect(x: self.view.frame.width / 9, y: self.view.frame.width / 3, width: self.view.frame.width / 1.25, height: self.view.frame.width / 1.25)
        })
    }
}
