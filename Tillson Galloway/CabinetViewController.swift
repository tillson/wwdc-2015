//
//  CabinetViewController.swift
//  Tillson Galloway
//
//  Created by Tillson on 4/14/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit
import WebKit

class CabinetViewController: UICollectionViewController {
    
    var cards = [CardObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = nil
        
        cards.append(CardObject(title: "About Me", body: "I am the one who knocks."))
        cards.append(CardObject(title: "Education", body: "Hey, that's a Modest Mouse song!"))
        
        let obj = CardObject(title: "Past Work", body: "")
        let webView = WKWebView(frame: CGRect(x: 50, y: 125, width: view.frame.width - 100, height: 250))
        let path = NSBundle.mainBundle().pathForResource("pastwork", ofType: "html")!
        webView.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: path, isDirectory: false)!))
        obj.customView = webView
        cards.append(obj)
        
        cards.append(CardObject(title: "Timeline", body: "A game"))
        collectionView?.registerNib(UINib(nibName: "PassCard", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "pass")
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
        if let customView = cards[indexPath.row].customView {
            card.customView = customView
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
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            let card = collectionView.cellForItemAtIndexPath(indexPath) as! PassCard
            card.clipsToBounds = false
            card.autoresizesSubviews = false
            if let customView = card.customView {
                let point = card.convertPoint(customView.frame.origin, toView: self.view)
                customView.removeFromSuperview()
                self.view.addSubview(customView)
                customView.frame.origin = point
                UIView.animateWithDuration(0.5, animations: {
                    customView.frame = self.view.frame
                    }, completion: { finished in
//                        self.performSegueWithIdentifier("showCard", sender: self)
                })
            }
        }
    }
    
}

