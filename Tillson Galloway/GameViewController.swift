//
//  GameViewController.swift
//  Tillson Galloway
//
//  Created by Tillson on 4/20/15.
//  Copyright (c) 2014 Tillson Galloway. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import CoreMotion

class GameViewController: UIViewController {
    
    let CollisionCategoryPlayer = 1
    let CollisionCategoryKiller = 2
    
    let sceneView = SCNView()
    let scene = SCNScene()

    let cameraNode = SCNNode()
    let motionManager = CMMotionManager()
    let mainNode = SCNNode()
    
    var moving: SCNNode!
    var character: SCNNode!
    
    var pipeMoveAction: SCNAction!
    
    var offset = 0.0
    
    
    var inProgress = false
    
    var timelineArray = [String]()
    var timelineIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.frame = view.frame
        view.addSubview(sceneView)

        sceneView.backgroundColor = UIColor(red: 133.0 / 255.0, green: 197.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
        sceneView.showsStatistics = true
        
        sceneView.scene = scene
        
        scene.physicsWorld.gravity = SCNVector3(x: 0, y: -30.0, z: 0)
        scene.physicsWorld.contactDelegate = self
        
        mainNode.position = SCNVector3(x: 0, y: 0, z: -40)

        scene.rootNode.addChildNode(mainNode)
        
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 80)
        cameraNode.camera?.zFar = 200.0
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView.autoenablesDefaultLighting = true
        
        let characterGeom = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 0)
        characterGeom.firstMaterial?.diffuse.contents = UIColor.redColor()
        
        character = SCNNode(geometry: characterGeom)
        character.position = SCNVector3(x: 0, y: 0, z: -15)
        character.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: SCNPhysicsShape(node: character, options: nil))
        character.physicsBody?.mass = 1.0
        character.physicsBody?.rollingFriction = 1.0
        character.physicsBody?.damping = 0.0
        character.physicsBody?.categoryBitMask = CollisionCategoryPlayer
        character.physicsBody?.collisionBitMask = CollisionCategoryKiller

        mainNode.addChildNode(character)
        
        
        let path = NSBundle.mainBundle().pathForResource("timeline", ofType: "json")!
        let jsonData = NSData(contentsOfFile: path)
        var jsonResult = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSMutableArray
        for entry in jsonResult {
            timelineArray.append(entry as! String)
        }
        
        setupPipes()
        setupScenery()
        
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        
        // TODO: Take this off the main queue
        motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryCorrectedZVertical, toQueue: NSOperationQueue.mainQueue(), withHandler: {(motion, error) -> Void in
            let value = self.offset + motion.attitude.roll * 4
        
            // Snap into place
            if (abs(value) > 0.1 && (abs(value) < 1.70 || abs(value) > 1.90)) {
                self.mainNode.eulerAngles = SCNVector3(x: 0, y: Float(value), z: 0)
            } else {
                self.mainNode.eulerAngles = SCNVector3(x: 0, y: abs(value) < 0.1 ? 0 : 1.80*(value < 0 ? -1 : 1), z: 0)
            }
            
        })
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        let gestureRecognizers = NSMutableArray()
        gestureRecognizers.addObject(tapGesture)
        if let existingGestureRecognizers = sceneView.gestureRecognizers {
            gestureRecognizers.addObjectsFromArray(existingGestureRecognizers)
        }
        sceneView.gestureRecognizers = gestureRecognizers as [AnyObject]
        
        inProgress = true
        
    }
    
    func setupScenery() {
        let groundGeom = SCNBox(width: 150, height: 1, length: 250, chamferRadius: 0)
        groundGeom.firstMaterial?.diffuse.contents = UIColor.fromRGB(0x00ff00)
        let groundNode = SCNNode(geometry: groundGeom)
        groundNode.position = SCNVector3(x: 0, y: -80, z: -175)
        groundNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Kinematic, shape: SCNPhysicsShape(node: groundNode, options: nil))
        groundNode.physicsBody?.categoryBitMask = CollisionCategoryKiller
        groundNode.physicsBody?.collisionBitMask = CollisionCategoryPlayer

        scene.rootNode.addChildNode(groundNode)
    }
    
    func setupPipes() {
        let spawnAction = SCNAction.runBlock({ (node: SCNNode!) in self.spawnPipes() })
        let delay = SCNAction.waitForDuration(4.0)
        
        mainNode.runAction(SCNAction.repeatActionForever(SCNAction.sequence([spawnAction, delay])), forKey: "masterPipe")
    }
    
    func spawnPipes() {
        if !inProgress {
            return
        }
        timelineIndex++
        
        let moveAction = SCNAction.moveByX(0, y: 0, z: 150, duration: 6.5)
        let removeAction = SCNAction.removeFromParentNode()
        let action = SCNAction.sequence([moveAction, removeAction])
        
        let pipeNode = SCNNode()
        pipeNode.position = SCNVector3(x: 0, y: 40, z: -70)
        
        let pipeA = SCNBox(width: 50, height: 60, length: 5, chamferRadius: 0)
        pipeA.firstMaterial?.diffuse.contents = UIColor.fromRGB(0x17A633)
        let pipeANode = SCNNode(geometry: pipeA)
        pipeANode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Kinematic, shape: SCNPhysicsShape(node: pipeANode, options: nil))
        pipeANode.physicsBody?.categoryBitMask = CollisionCategoryKiller
        pipeANode.physicsBody?.collisionBitMask = CollisionCategoryPlayer
        pipeANode.position = SCNVector3(x: 0, y: 0, z: -30)
        pipeNode.addChildNode(pipeANode)
        
        let textGeom = SCNText(string: timelineArray[timelineIndex], extrusionDepth: 0.1)
        textGeom.containerFrame = CGRect(x: -20, y: -31, width: 40, height: 60) // this has the weirdest coordinate system ever
        textGeom.font = UIFont.systemFontOfSize(6.0)
        textGeom.alignmentMode = kCAAlignmentCenter
        textGeom.truncationMode = kCATruncationMiddle
        textGeom.wrapped = true
        let text = SCNNode(geometry: textGeom)
        text.position = SCNVector3(x: 0, y: 0, z: -27.5)
        pipeNode.addChildNode(text)
        
        let pipeB = SCNBox(width: 50, height: 60, length: 5, chamferRadius: 0)
        pipeB.firstMaterial?.diffuse.contents = UIColor.fromRGB(0x17A633)
        let pipeBNode = SCNNode(geometry: pipeB)
        pipeBNode.position = SCNVector3(x: 0, y: -90, z: -30)
        pipeBNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Kinematic, shape: SCNPhysicsShape(node: pipeBNode, options: nil))
        pipeBNode.physicsBody?.categoryBitMask = CollisionCategoryKiller
        pipeBNode.physicsBody?.collisionBitMask = CollisionCategoryPlayer
        pipeNode.addChildNode(pipeBNode)
        
        pipeNode.runAction(action)
        moving = pipeNode
        mainNode.addChildNode(pipeNode)
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        if inProgress {
            character.physicsBody?.velocity = SCNVector3(x: 0, y: 0, z: 0)
            character.physicsBody?.applyForce(SCNVector3(x: 0, y: 30.0, z: 0), impulse: true)
        } else {
            // check what is being tapped
            if !GameCheatMode {
                
            }
        }
    }
    
    func finish(win: Bool) {
        inProgress = false
        mainNode.removeActionForKey("masterPipe")
        moving.removeAllActions()
        character.position = SCNVector3(x: 0, y: -30, z: -15)
        character.physicsBody?.velocity = SCNVector3(x: 0, y: 0, z: 0)
        let text = SCNNode(geometry: SCNText(string: (win ? "You did it!" : "You lose."), extrusionDepth: 0.3))
        var v1 = SCNVector3(x: 0, y: 0, z: 0)
        text.getBoundingBoxMin(nil, max: &v1)
        text.position = SCNVector3(x: -(v1.x / 2), y: -10, z: 0)
        mainNode.addChildNode(text)
        if !win && !GameCheatMode {
            let helpPlane = SCNPlane(width: 40, height: 12)
            helpPlane.firstMaterial?.diffuse.contents = UIImage(named: "cheatmode.gif")
            let helpNode = SCNNode(geometry: helpPlane)
            helpNode.position = SCNVector3(x: 6, y: character.position.y + 9, z: -15)
            mainNode.addChildNode(helpNode)
        }
        character.physicsBody?.velocityFactor = SCNVector3(x: 0, y: 0, z: 0)
    }

    
}

extension GameViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact){
        if !inProgress {
            return
        }
        
        let contactMask = contact.nodeA.physicsBody!.categoryBitMask | contact.nodeB.physicsBody!.categoryBitMask
        if contact.nodeB.physicsBody!.categoryBitMask == CollisionCategoryPlayer && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategoryKiller {
            finish(false)
        }
        
    }
    
}
