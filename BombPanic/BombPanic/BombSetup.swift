//
//  BombSetup.swift
//  BombPanic
//
//  Created by Isaias Rosario on 7/31/15.
//  Copyright (c) 2015 Isaias Rosario. All rights reserved.
//

import Foundation
import SpriteKit

class Bomb : SKSpriteNode{

    var gameScene = GameScene?()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(imageNamed: String) {
        let bomb = SKTexture(imageNamed: imageNamed)
        super.init(texture: bomb, color: nil, size: bomb.size())
        userInteractionEnabled = true
        
        
    }
    
    // Moves sprite nodes when touches are moved
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch in (touches as! Set<UITouch>) {
            // Set sprite touch location
            let location = touch.locationInNode(scene)
            let touchedNode = nodeAtPoint(location)
            
                
                // Move node to touch location and scale sprite up
                touchedNode.position = location
                touchedNode.physicsBody?.categoryBitMask = PhysicsCategory.None
                touchedNode.physicsBody?.collisionBitMask = PhysicsCategory.None
                touchedNode.physicsBody?.contactTestBitMask = PhysicsCategory.None
                touchedNode.yScale = 3
                touchedNode.xScale = 3
                // Plays sound while being moved
                runAction(SKAction.playSoundFileNamed("grab.wav", waitForCompletion: false))
                
        }
    }
    
    // Check to see when touches have began on screen
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(scene)
            let touchedNode = nodeAtPoint(location)
            
        }
    }
    
    // Check to see when touched have ended on screen
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch in (touches as! Set<UITouch>) {
            
            let location = touch.locationInNode(scene)
            let touchedNode = nodeAtPoint(location)
            
        touchedNode.physicsBody?.categoryBitMask = PhysicsCategory.Bomb
        touchedNode.physicsBody?.collisionBitMask = PhysicsCategory.Bomb | PhysicsCategory.Wall
        touchedNode.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb | PhysicsCategory.Wall
            // Resize back to normal
            xScale = 2
            yScale = 2
        }
    }
}


