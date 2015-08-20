//
//  GameOverScene.swift
//  BombPanic
//
//  Created by Isaias Rosario on 7/31/15.
//  Copyright (c) 2015 Isaias Rosario. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class SecondScene: SKScene {
    var defaults = NSUserDefaults.standardUserDefaults()
    var highScore = 0
    var count: AnyObject?
    var score_1 = 0
    var score_2 = 0
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.redColor()
        
        // Set count to internal saved score
        count = defaults.objectForKey("Score")
        
        // Check if there is a high score saved
        if defaults.objectForKey("High_Score") == nil{
        
            defaults.setObject(highScore, forKey : "High_Score")
        
        }else{
        
            var saved: AnyObject? = defaults.objectForKey("High_Score")
            if let scoreSaved = saved as? Int{
                highScore = scoreSaved
            }
        
        }
        
        // Set scores for the labels and save high score 
        if let checkScore = count as? Int{
        
            if checkScore > highScore {
                
                score_1 = checkScore
                score_2 = checkScore
                highScore = score_2
                
                defaults.setObject(highScore, forKey : "High_Score")
                
                
                // Sends High Score to Game Center
                saveHighscore(highScore)
                
                println("high score")
            
            }else{
                
                var saved: AnyObject? = defaults.objectForKey("High_Score")
            
                score_1 = checkScore
                score_2 = highScore
                
                println("score")
            
            }
        
        }
        
        let score1 = SKLabelNode(fontNamed:"Chalkduster")
        score1.text = "score: \(score_1)";
        score1.fontSize = 100;
        score1.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+200);
        self.addChild(score1)
        
        let score2 = SKLabelNode(fontNamed:"Chalkduster")
        score2.text = "highest score: \(score_2)";
        score2.fontSize = 50;
        score2.fontColor = SKColor.yellowColor()
        score2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+100);
        self.addChild(score2)
        
        
        var button = SKSpriteNode(imageNamed: "retry.png")
        button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100)
        button.name = "retry"
        
        self.addChild(button)
        
        var button2 = SKSpriteNode(imageNamed: "home.png")
        button2.position = CGPointMake(CGRectGetMidX(self.frame)-320, CGRectGetMidY(self.frame)-100)
        button2.name = "home"
        
        self.addChild(button2)
        
        var button3 = SKSpriteNode(imageNamed: "score.png")
        button3.position = CGPointMake(CGRectGetMidX(self.frame)+320, CGRectGetMidY(self.frame)-100)
        button3.name = "score"
        
        self.addChild(button3)
        
    }
    
    // Save high score to Gmae Center function
    func saveHighscore(score:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            //Leaderboard for all scores
            var scoreReporter = GKScore(leaderboardIdentifier: "testLeader") //leaderboard id
            
            scoreReporter.value = Int64(score) //score variable
            
            var scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError!) -> Void in
                if error != nil {
                    println("error")
                }
            })
            
            // Leaderboard for most recent scores
            var scoreReporter1 = GKScore(leaderboardIdentifier: "testLeader1") //leaderboard id
            
            scoreReporter1.value = Int64(score) //score variable
            
            var scoreArray1: [GKScore] = [scoreReporter1]
            
            GKScore.reportScores(scoreArray1, withCompletionHandler: {(error : NSError!) -> Void in
                if error != nil {
                    println("error")
                }
            })
            println("submitted score")
            
        }
        
    }

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var touch = touches as!  Set<UITouch>
        var location = touch.first!.locationInNode(self)
        var node = self.nodeAtPoint(location)
        
        // Rerty Button
        if (node.name == "retry") {
            var gameScene = GameScene(fileNamed: "GameScene")
            gameScene.size = self.size
            var transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
            gameScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(gameScene, transition: transition)
        }
        
        // Home Button
        if (node.name == "home") {
            var menuScene = MenuScene(fileNamed: "MenuScene")
            menuScene.size = self.size
            var transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
            menuScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(menuScene, transition: transition)
        }
        
        // Score Button
        if (node.name == "score") {
            var scoreScene = ScoreScene(fileNamed: "ScoreScene")
            scoreScene.size = self.size
            var transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
            scoreScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(scoreScene, transition: transition)
        }
    }
    
    
}
   