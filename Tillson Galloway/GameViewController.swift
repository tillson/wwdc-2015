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
    
    let cameraNode = SCNNode()
    let motionManager = CMMotionManager()
    let mainNode = SCNNode()
    
    var character: SCNNode!
    
    let sceneView = SCNView()
    let scene = SCNScene()
    
    var pipeMoveAction: SCNAction!
    
    var offset = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.frame = view.frame
        view.addSubview(sceneView)

        sceneView.backgroundColor = UIColor(red: 133.0 / 255.0, green: 197.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
        sceneView.showsStatistics = true
        
        sceneView.scene = scene
        
        scene.physicsWorld.gravity = SCNVector3(x: 0, y: -30.0, z: 0)
        
        mainNode.position = SCNVector3(x: 0, y: 0, z: -40)
        
        scene.rootNode.addChildNode(mainNode)
        
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 80)
        cameraNode.camera?.zFar = 200.0
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView.autoenablesDefaultLighting = true
        
        let characterGeom = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 4)
        characterGeom.firstMaterial?.diffuse.contents = UIColor.redColor()
        
        character = SCNNode(geometry: characterGeom)
        character.position = SCNVector3(x: 20, y: 0, z: -15)
        character.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: SCNPhysicsShape(node: character, options: nil))
        character.physicsBody?.mass = 1.0
        mainNode.addChildNode(character)
        
        setupPipes()
        
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
        
    }
    
    func setupPipes() {
        let spawnAction = SCNAction.runBlock({ (node: SCNNode!) in self.spawnPipes() })
        let delay = SCNAction.waitForDuration(4.0)
        
        mainNode.runAction(SCNAction.repeatActionForever(SCNAction.sequence([spawnAction, delay])))
    }
    
    func spawnPipes() {
        let moveAction = SCNAction.moveByX(0, y: 0, z: 150, duration: 6.5)
        let removeAction = SCNAction.removeFromParentNode()
        let action = SCNAction.sequence([moveAction, removeAction])
        
        let pipeNode = SCNNode()
        pipeNode.position = SCNVector3(x: 0, y: 40, z: -70)
        
        let pipeA = SCNBox(width: 50, height: 60, length: 5, chamferRadius: 0)
        pipeA.firstMaterial?.diffuse.contents = UIColor.greenColor()
        let pipeANode = SCNNode(geometry: pipeA)
        pipeANode.position = SCNVector3(x: 0, y: 0, z: -30)
        
        pipeNode.addChildNode(pipeANode)
        
        let pipeB = SCNBox(width: 50, height: 60, length: 5, chamferRadius: 0)
        pipeB.firstMaterial?.diffuse.contents = UIColor.greenColor()
        let pipeBNode = SCNNode(geometry: pipeB)
        pipeBNode.position = SCNVector3(x: 0, y: -90, z: -30)
        pipeNode.addChildNode(pipeBNode)
        
        pipeNode.runAction(action)
        mainNode.addChildNode(pipeNode)
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        character.physicsBody?.velocity = SCNVector3(x: 0, y: 0, z: 0)
        character.physicsBody?.applyForce(SCNVector3(x: 0, y: 30.0, z: 0), impulse: true)
    }
    
}

extension GameViewController: SCNSceneRendererDelegate {
    
    func renderer(aRenderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
    }

    
}
