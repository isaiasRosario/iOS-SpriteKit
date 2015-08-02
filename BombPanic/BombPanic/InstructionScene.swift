//
//  InstructionScene.swift
//  BombPanic
//
//  Created by Isaias Rosario on 7/31/15.
//  Copyright (c) 2015 Isaias Rosario. All rights reserved.
//

import Foundation
import SpriteKit


class InstructionScene: SKScene {
    
    override func didMoveToView(view: SKView) {

        var button = SKSpriteNode(imageNamed: "home.png")
        button.yScale = 0.5
        button.xScale = 0.5
        button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-200)
        button.name = "home"
        
        self.addChild(button)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch = touches as!  Set<UITouch>
        var location = touch.first!.locationInNode(self)
        var node = self.nodeAtPoint(location)
        
        // If previous button is touched, start transition to previous scene
        if (node.name == "home") {
            var menuScene = MenuScene(fileNamed: "MenuScene")
            menuScene.size = self.size
            var transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
            menuScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(menuScene, transition: transition)
        }
    }
}