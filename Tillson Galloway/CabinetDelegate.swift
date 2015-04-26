//
//  CabinetDelegate.swift
//  Tillson Galloway
//
//  Created by Tillson on 4/19/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit
import MapKit

protocol CabinetDelegate {
    
    func moreInfoButtonPressed(card: CardObject)
    func openMapForRegion(region: MKCoordinateRegion)
    
}
