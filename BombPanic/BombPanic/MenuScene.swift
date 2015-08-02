//
//  MenuScene.swift
//  BombPanic
//
//  Created by Isaias Rosario on 7/31/15.
//  Copyright (c) 2015 Isaias Rosario. All rights reserved.
//

import Foundation
import SpriteKit


class MenuScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blueColor()
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch = touches as!  Set<UITouch>
        var location = touch.first!.locationInNode(self)
        var node = self.nodeAtPoint(location)
        
        // If previous button is touched, start transition to previous scene
        if (node.name == "startLabel" || node.name == "start") {
            var gameScene = GameScene(fileNamed: "GameScene")
            gameScene.size = self.size
            var transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
        if (node.name == "creditLabel" || node.name == "credit") {
            var creditScene = CreditScene(fileNamed: "CreditScene")
            creditScene.size = self.size
            var transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
            creditScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(creditScene, transition: transition)
        }
        if (node.name == "howLabel" || node.name == "how") {
            var howScene = InstructionScene(fileNamed: "InstructionScene")
            howScene.size = self.size
            var transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
            howScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(howScene, transition: transition)
        }
    }
    
    
}
   