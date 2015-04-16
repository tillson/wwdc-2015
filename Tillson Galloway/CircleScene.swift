//
//  CircleScene.swift
//  DubDubTest
//
//  Created by Tillson on 4/14/15.
//  Copyright (c) 2015 Tillson Galloway. All rights reserved.
//

import UIKit
import SpriteKit

class CircleScene: SKScene {
   
    let ballNode = SKEmitterNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.fromRGB(0xE4E0E4)
        setupBall()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBall() {
        ballNode.particleTexture = SKTexture(imageNamed: "circle")

        ballNode.particleBirthRate = 5
        ballNode.particleSpeedRange = 0.2
        
        ballNode.particleLifetime = 2.5

        ballNode.particlePosition = CGPoint(x: frame.size.width / 2, y: frame.size.height / 4)
        ballNode.particlePositionRange = CGVector(dx: 160, dy: 50)
        
        ballNode.alpha = 0.8
        ballNode.particleAlphaRange = 0.2
        ballNode.particleAlphaSpeed = -0.7
        
        ballNode.particleScale = 0.2
        ballNode.particleScaleSpeed = 0.45
        ballNode.yAcceleration = 100
        ballNode.particleColorBlendFactor = 35
        
        addChild(ballNode)
    }
    
    override func update(currentTime: NSTimeInterval) {
        ballNode.particleColor = UIColor(hue: CGFloat(drand48()), saturation: 1.0, brightness: 1.0, alpha: 0.5)
        ballNode.xAcceleration = CGFloat(arc4random_uniform(200)) - 100.0
    }
    
}
