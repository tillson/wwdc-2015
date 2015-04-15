//
//  CabinetViewController.swift
//  Tillson Galloway
//
//  Created by Tillson on 4/14/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit

class CabinetViewController: UICollectionViewController {
    
    var cards = [CardObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cards.append(CardObject(title: "About Me", body: "I am who I am.  I am the one who knocks."))
        cards.append(CardObject(title: "Education", body: "Hey, that's a Modest Mouse song!"))
        for i in 1...12 {
            cards.append(CardObject(title: "\(i)", body: "boop"))
        }
        collectionView?.registerNib(UINib(nibName: "PassCard", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "pass")
    }
        
    // MARK: Collection View Stuff
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let card: PassCard = collectionView.dequeueReusableCellWithReuseIdentifier("pass", forIndexPath: indexPath) as! PassCard
        card.cardTitle.text = cards[indexPath.row].title
        card.cardBody.text = cards[indexPath.row].body
        return card
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
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

