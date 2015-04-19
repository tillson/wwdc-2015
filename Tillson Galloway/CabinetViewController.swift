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
        
        cards.append(CardObject(title: "", body: "", imageName: ""))
        cards.append(CardObject(title: "About Me", body: "I am the one who knocks.", imageName: "card-red"))
        cards.append(CardObject(title: "Education", body: "Hey, that's a Modest Mouse song!", imageName: "card-red"))
        
        let obj = CardObject(title: "Past Work", body: "In the past, I've worked on a vareity of apps, including: iSignedIn, Timed Test, and a vareity of open source projects at my school.", imageName: "card-orange")
        let scrollView = UIScrollView(frame: CGRect(x: 50, y: 125, width: view.frame.width - 100, height: 250))
        let array = NSBundle.mainBundle().loadNibNamed("PastWorkScroll", owner: self, options: nil)
        let pastWorkView = array[0] as! PastWorkScroll
        pastWorkView.scrollView = scrollView
        scrollView.addSubview(pastWorkView)
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.contentSize = pastWorkView.frame.size
        obj.customView = scrollView
        
        cards.append(obj)
        
        cards.append(CardObject(title: "Timeline", body: "A game", imageName: "card-red"))
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
        card.cardBackground.image = UIImage(named: cards[indexPath.row].imageName)
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
    }
    
}

