//
//  ScoreScene.swift
//  BombPanic
//
//  Created by Isaias Rosario on 8/19/15.
//  Copyright (c) 2015 Isaias Rosario. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class ScoreScene: SKScene, GKGameCenterControllerDelegate {
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blueColor()
        
        authenticateLocalPlayer()
        
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
        
        // All Button
        if (node.name == "allLabel" || node.name == "all") {
            showLeader("testLeader")
 
        }
        // Today Button
        if (node.name == "dayLabel" || node.name == "day") {
            showLeader("testLeader1")

        }
        // Home Button
        if (node.name == "home") {
            var menuScene = MenuScene(fileNamed: "MenuScene")
            menuScene.size = self.size
            var transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
            menuScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(menuScene, transition: transition)
        }
    }
    
    // Sign into Game Center
    func authenticateLocalPlayer(){
        
        println("Auth")
        
        var localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if ((viewController) != nil) {
                self.view!.window?.rootViewController!.presentViewController(viewController, animated: true, completion: nil)
            }
                
            else {
                println((GKLocalPlayer.localPlayer().authenticated))
            }
        }
        
    }
    
    //show leaderboard screen
    func showLeader(id:String) {
        var vc = self.view?.window?.rootViewController

        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        gc.leaderboardIdentifier = id
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    //hide leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}
