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
    
    var overlayView: UIView?
    
    let transitionManager = PocketTransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        cards.append(CardObject(title: "", body: "", imageName: ""))
        
        cards.append(CardObject(title: "About Me", body: "", imageName: "card-red", attributedBody: getBioText()))

        let pastWork = CardObject(title: "Past Work", body: "In the past, I've worked on a variety of apps, including: iSignedIn, Timed Test, and an array of open source projects at my school.", imageName: "card-orange")
        pastWork.moreInfoViewController = PastWorkViewController.self
        cards.append(pastWork)
        
        cards.append(CardObject(title: "Technical Skills", body: Utilities.getFileContents("skills", type: "txt"), imageName: "card-green"))
        
        let timeline = CardObject(title: "Timeline", body: Utilities.getFileContents("game", type: "txt"), imageName: "card-blue")
        timeline.moreInfoViewController = GameViewController.self
        cards.append(timeline)
        
        collectionView?.registerNib(UINib(nibName: "PassCard", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "pass")
        
    }
    
    func getBioText() -> NSAttributedString {
        
        var originalString = Utilities.getFileContents("bio", type: "txt")
        var attributedString = NSMutableAttributedString(string: originalString)
        
        var textRange = NSRange(location: 0, length: attributedString.length)
        let regex = NSRegularExpression(pattern: "\\[(.*?)\\]", options: nil, error: nil)!
        
        let matches = regex.matchesInString(originalString, options: NSMatchingOptions.WithoutAnchoringBounds, range: textRange)
        attributedString.addAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], range: textRange)

        for match in matches as! [NSTextCheckingResult] {
            let matchRange = NSRange(location: match.range.location, length: match.range.length - 1)
            var text = (originalString as NSString).substringWithRange(match.range)
            text = text.stringByReplacingOccurrencesOfString("[", withString: "").stringByReplacingOccurrencesOfString("]", withString: "").stringByReplacingOccurrencesOfString("-", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
            attributedString.beginEditing()
            attributedString.addAttribute(NSLinkAttributeName, value: "map://\(text)", range: matchRange)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: matchRange)
            attributedString.addAttribute(NSUnderlineStyleAttributeName, value: 1, range: matchRange)
            attributedString.endEditing()
        }
        attributedString.mutableString.replaceOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSRange(location: 0, length: attributedString.mutableString.length))
        attributedString.mutableString.replaceOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSRange(location: 0, length: attributedString.mutableString.length))

        
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
            card.cardBody.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.fromRGB(0xADD8E6)]
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
        if overlayView != nil {
            return false
        }

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
    
    
    func didTouchOverlay(touchEvent: UITapGestureRecognizer) {
        closeMap()
    }
    
}

extension CabinetViewController: CabinetDelegate {
    
    func moreInfoButtonPressed(card: CardObject) {
        if let moreVC: UIViewController.Type = card.moreInfoViewController {
            self.presentViewController(moreVC(), animated: true, completion: nil)
        }
    }
    
    func openMapForRegion(region: MKCoordinateRegion, title: String) {
        if overlayView != nil {
            return
        }
        
        overlayView = UIView()
        overlayView?.frame = view.frame
        
        let popupView = UIView()
        popupView.frame = view.frame
        popupView.backgroundColor = UIColor.blackColor()
        popupView.alpha = 0.0
        overlayView!.addSubview(popupView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "didTouchOverlay:")
        tapGesture.numberOfTapsRequired = 1
        popupView.addGestureRecognizer(tapGesture)

        let mapView = MKMapView()
        mapView.frame = CGRect(x: view.frame.width / 2, y: view.frame.height / 2, width: 0, height: 0)
        mapView.mapType = .Hybrid
        mapView.setRegion(region, animated: false)
        mapView.layer.borderColor = UIColor.whiteColor().CGColor
        mapView.layer.borderWidth = 2.0
        overlayView!.addSubview(mapView)
        
        let button = UIButton(frame: CGRect(x: view.frame.width -  self.view.frame.width / 9 - 5, y: self.view.frame.width / 2.5 - 20, width: 20, height: 20))
        button.setTitle("x", forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(20.0)
        button.addTarget(self, action: "closeMap", forControlEvents: .TouchUpInside)
        overlayView!.addSubview(button)
        
        let point = MKPointAnnotation()
        point.coordinate = region.center
        point.title = title
        mapView.addAnnotation(point)
        
        UIView.animateWithDuration(0.25, animations: {
            popupView.alpha = 0.3
            mapView.alpha = 1.0
            mapView.frame = CGRect(x: self.view.frame.width / 9, y: self.view.frame.width / 2.5, width: self.view.frame.width / 1.25, height: self.view.frame.width / 1.25)
        })
        
        view.addSubview(overlayView!)
    }
    
    func closeMap() {
        if let overlay = overlayView {
            UIView.animateWithDuration(0.25, animations: {
                for subviewAny in overlay.subviews {
                    if let subview = subviewAny as? UIView {
                        if subview is MKMapView {
                            subview.frame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 0, height: 0)
                            subview.alpha = 0.0
                        } else {
                            subview.alpha = 0.0
                        }
                    }
                }
                }, completion: { completion in
                    self.overlayView!.removeFromSuperview()
                    self.overlayView = nil
            })
            
        }
        
    }
}


extension CabinetViewController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionManager
    }
}

