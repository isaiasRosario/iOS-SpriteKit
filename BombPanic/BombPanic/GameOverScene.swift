//
//  GameOverScene.swift
//  BombPanic
//
//  Created by Isaias Rosario on 7/31/15.
//  Copyright (c) 2015 Isaias Rosario. All rights reserved.
//

import Foundation
import SpriteKit


class SecondScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.redColor()
        
        let over = SKLabelNode(fontNamed:"Chalkduster")
        over.text = "GAME OVER!";
        over.fontSize = 100;
        over.zPosition = 3.0
        over.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+100);
        self.addChild(over)
        
        
        var button = SKSpriteNode(imageNamed: "retry.png")
        button.position = CGPointMake(CGRectGetMidX(self.frame)+200, CGRectGetMidY(self.frame)-100)
        button.name = "retry"
        
        self.addChild(button)
        
        var button2 = SKSpriteNode(imageNamed: "home.png")
        button2.position = CGPointMake(CGRectGetMidX(self.frame)-200, CGRectGetMidY(self.frame)-100)
        button2.name = "home"
        
        self.addChild(button2)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch = touches as!  Set<UITouch>
        var location = touch.first!.locationInNode(self)
        var node = self.nodeAtPoint(location)
        
        // If previous button is touched, start transition to previous scene
        if (node.name == "retry") {
            var gameScene = GameScene(fileNamed: "GameScene")
            gameScene.size = self.size
            var transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
        if (node.name == "home") {
            var menuScene = MenuScene(fileNamed: "MenuScene")
            menuScene.size = self.size
            var transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
            menuScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(menuScene, transition: transition)
        }
    }
    
    
}
   