//
//  GameScene.swift
//  bombTest
//
//  Created by Isaias Rosario on 7/15/15.
//  Copyright (c) 2015 Isaias Rosario. All rights reserved.
//

import SpriteKit
import AVFoundation


// Physic Categories for Sprites
struct PhysicsCategory {
    static let Bomb      : UInt32 = 0x1 << 0
    static let Wall      : UInt32 = 0x1 << 1
    static let None      : UInt32 = 0x2 << 2
    static let Floor      : UInt32 = 0x2 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Global Variables
    var bg: SKSpriteNode!
    var cage: SKSpriteNode!
    var play: SKSpriteNode!
    var bomb: SKSpriteNode!
    var bomb2: SKSpriteNode!
    var bombWalk: SKAction!
    var bombExp: SKAction!
    var bombWalk2: SKAction!
    var seq: SKAction!
    var rseq: SKAction!
    var seq2: SKAction!
    var backgroundMusicPlayer: AVAudioPlayer!
    var count = 0
    let score = SKLabelNode(fontNamed:"Chalkduster")

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let cageFloor = childNodeWithName("cageFloor")
        cageFloor?.userInteractionEnabled = false
        cageFloor?.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        cageFloor?.physicsBody?.collisionBitMask = PhysicsCategory.Bomb
        cageFloor?.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb
        
        score.text = "0";
        score.fontSize = 45;
        score.zPosition = 3.0
        score.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+185);
        self.addChild(score)

        
        // Setup background image for game secene
        bg = SKSpriteNode(imageNamed: "bg.jpg")
        bg.size = self.frame.size
        bg.userInteractionEnabled = false
        bg.zPosition = 0.0
        bg.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(bg)
        
        // Setup play button to start game
        play = SKSpriteNode(imageNamed: "play.png")
        play.name = "play"
        play.xScale = 3
        play.yScale = 3
        play.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(play)
        
        // Setup for background music loop
        var error: NSError?
        let backgroundMusicURL = NSBundle.mainBundle().URLForResource("bg", withExtension: "wav")
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error: &error)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.volume = 0.15
        
        // Setup to make screen edges act like a wall using physics body
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame.standardizedRect)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        self.physicsBody?.collisionBitMask = PhysicsCategory.Bomb
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        self.physicsWorld.contactDelegate = self;
        self.physicsBody?.friction = 0.0
        //self.physicsWorld.speed = 1
        
    }
    
    func random() ->CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(#min: CGFloat, max:CGFloat) ->CGFloat{
        return random()*(max-min)+min
    }
    
    
    // Function to setup and spawn bomb sprites
    func setupBomb(){
        
        // Play sound when sprite has spawned
        runAction(SKAction.playSoundFileNamed("spawn.wav", waitForCompletion: false))
        
        // Bomb sprite node property set up
        bomb = Bomb(imageNamed: "sprite_left_1.png")
        bomb.name = "bomb"
        bomb.yScale = 2
        bomb.xScale = 2
        bomb.zPosition = 2.0
        bomb.position = CGPoint(x: CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: (bomb.size.width / 2) )
        bomb.physicsBody?.categoryBitMask = PhysicsCategory.Bomb
        bomb.physicsBody?.collisionBitMask = PhysicsCategory.Bomb | PhysicsCategory.Wall
        bomb.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb | PhysicsCategory.Wall
        bomb.physicsBody?.dynamic = true
        bomb.physicsBody?.restitution = 1
        bomb.physicsBody?.friction = 0.0
        bomb.physicsBody?.linearDamping = 0.0
        //bomb.physicsBody?.allowsRotation = true
        self.addChild(bomb)
        
        // Bomb2 sprite node property set up
//        bomb2 = Bomb(imageNamed: "blue_sprite_right_1.png")
//        bomb2.name = "bomb2"
//        bomb2.yScale = 2
//        bomb2.xScale = 2
//        bomb2.position = CGPoint(x: CGRectGetMidX(self.frame)+50, y: CGRectGetMidY(self.frame))
//        bomb2.physicsBody = SKPhysicsBody(circleOfRadius: (bomb.size.width / 2.6) )
//        bomb2.physicsBody?.categoryBitMask = PhysicsCategory.Bomb
//        bomb2.physicsBody?.collisionBitMask = PhysicsCategory.Bomb | PhysicsCategory.Wall
//        bomb2.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb | PhysicsCategory.Wall
//        bomb2.physicsBody?.dynamic = true
//        bomb2.physicsBody?.restitution = 1
//        bomb2.physicsBody?.friction = 0.0
//        bomb2.physicsBody?.linearDamping = 0.0
//        //bomb2.physicsBody?.allowsRotation = true
//        self.addChild(bomb2)
        
        // Walking sound for bombs
        let sound = SKAction.playSoundFileNamed("fuse.mp3", waitForCompletion: true)
        let wSound = SKAction.repeatActionForever(sound)
        
        // Atals for bomb animation setup
        let atlas = SKTextureAtlas(named: "bomb")
        
            let anim = SKAction.animateWithTextures([
                atlas.textureNamed("sprite_left_1.png"),
                atlas.textureNamed("sprite_left_2.png"),
                atlas.textureNamed("sprite_left_3.png"),
                atlas.textureNamed("sprite_left_4.png")
                ], timePerFrame: 0.09)
        
            bombWalk = SKAction.repeatActionForever(anim)
        
        
        let atlasExp = SKTextureAtlas(named: "explode")
        let expSound = SKAction.playSoundFileNamed("explode.wav", waitForCompletion: false)
        
        let exp = SKAction.animateWithTextures([
            atlasExp.textureNamed("ex1.png"),
            atlasExp.textureNamed("ex2.png"),
            atlasExp.textureNamed("ex3.png"),
            atlasExp.textureNamed("ex4.png"),
            atlasExp.textureNamed("ex5.png"),
            atlasExp.textureNamed("ex6.png")
            ], timePerFrame: 0.09)
        
        let blowUp = SKAction.scaleBy(1.5, duration: 0.5)
        
        // Run explode animation action and remove node after completion
        let rem = SKAction.removeFromParent()
        let seqExp = SKAction.sequence([SKAction.waitForDuration(9), blowUp, expSound, exp, rem])
        
        

            bomb.runAction(bombWalk)
            bomb.runAction(wSound, withKey: "wSound")
//            bomb.runAction(exp)
  
        bomb.runAction(seqExp, completion: {
//            self.scene?.view?.paused = true
            
            self.backgroundMusicPlayer.pause()
            self.bomb.removeFromParent()
            
            var secondScene = SecondScene(size: self.size)
            var transition = SKTransition.flipVerticalWithDuration(1.0)
            secondScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(secondScene, transition: transition)
            
        })
        
//        completion: {
//            self.userInteractionEnabled = false
//            
//            self.bomb.removeActionForKey("wSound")
//            
//        }

        
       
//            let anim2 = SKAction.animateWithTextures([
//                atlas.textureNamed("blue_sprite_right_1.png"),
//                atlas.textureNamed("blue_sprite_right_2.png"),
//                atlas.textureNamed("blue_sprite_right_3.png"),
//                atlas.textureNamed("blue_sprite_right_4.png")
//                ], timePerFrame: 0.09)
//            
//            bombWalk2 = SKAction.repeatActionForever(anim2)
//            bomb2.runAction(bombWalk2)
        
        // Moves sprite nodes
        let moveBomb = SKAction.moveByX(-500 , y: 0,duration: 4)
//        let moveBomb2 = SKAction.moveByX(self.frame.width, y: 0, duration: 6)
        let delay = SKAction.waitForDuration(0)
        let moveBack = moveBomb.reversedAction()
        seq = SKAction.sequence([delay, moveBomb, moveBack])
        rseq = SKAction.repeatActionForever(seq)
//        seq2 = SKAction.sequence([delay, moveBomb2])
        bomb.runAction(rseq, withKey: "seq")
//        bomb2.runAction(seq2, withKey: "seq2")
    
    }
    
    // Check to see when touches have began on screen
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch in (touches as! Set<UITouch>) {
            
            // Set sprite touch location
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            let pause = SKLabelNode()
            
            // Check to see if play button was touched to play game
            if touchedNode.name == "play"{
                
                touchedNode.removeFromParent()
                backgroundMusicPlayer.play()
                
                runAction(SKAction.repeatActionForever(
                    SKAction.sequence([
                        SKAction.runBlock(setupBomb),
                        SKAction.waitForDuration(5.0)
                        ])
                    ))
                
                
            }else if touchedNode.name == "pause"{
                
                if self.scene?.view?.paused == true{
                    self.scene?.view?.paused = false
                    backgroundMusicPlayer.play()

                }else if self.scene?.view?.paused == false{
                    self.scene?.view?.paused = true
                    backgroundMusicPlayer.pause()
                    
                }
                
                
                
                
                
            }
        }
    }

    
    // Check to see if edge or sprite nodes have made contact
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        // variables for two physics bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // Check physic bodies first contact
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB

        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Check to see which physics categories have contaced
        if firstBody.categoryBitMask == PhysicsCategory.Bomb && secondBody.categoryBitMask == PhysicsCategory.Bomb{
            println("You Hit Bomb.")
//            firstBody.node?.physicsBody?.applyImpulse(CGVector(
//                dx: CGFloat(1.2),
//                dy: CGFloat(1.2)))
//            
//            secondBody.node?.physicsBody?.applyImpulse(CGVector(
//                dx: CGFloat(1.2),
//                dy: CGFloat(1.2)))
        
    
            // Play explode sound whne bobs contact
//            runAction(SKAction.playSoundFileNamed("explode.wav", waitForCompletion: false))
//            
//            // Atlas setup for explode animation
//            let atlas = SKTextureAtlas(named: "explode")
//            
//            let exp = SKAction.animateWithTextures([
//                atlas.textureNamed("ex1.png"),
//                atlas.textureNamed("ex2.png"),
//                atlas.textureNamed("ex3.png"),
//                atlas.textureNamed("ex4.png"),
//                atlas.textureNamed("ex5.png"),
//                atlas.textureNamed("ex6.png")
//                ], timePerFrame: 0.09)
//            
//            // Run explode animation action and remove node after completion
//            firstBody.node?.runAction(exp, completion: {
//                firstBody.node?.removeFromParent()
//            })
//            secondBody.node?.runAction(exp, completion: {
//                secondBody.node?.removeFromParent()
//            })
//
//            // Stop action that plays walking sound
//            removeActionForKey("wSound")
        }
        
        // Check to see if sprite node hit the wall
        if firstBody.categoryBitMask == PhysicsCategory.Bomb && secondBody.categoryBitMask == PhysicsCategory.Wall {
            runAction(SKAction.playSoundFileNamed("bump.wav", waitForCompletion: false))

            println("Bomb Hit The Wall.")
            
//            firstBody.node?.physicsBody?.applyImpulse(CGVector(
//                dx: CGFloat(2),
//                dy: CGFloat(2)))
        
        }
        if firstBody.categoryBitMask == PhysicsCategory.Bomb && secondBody.categoryBitMask == PhysicsCategory.Floor {
            firstBody.node?.userInteractionEnabled = false
            println("Bomb Has Been Defused!")
            
            count = count+1
            
            println(count)
            score.text = String(count)
            
            firstBody.node?.removeAllActions()
            firstBody.node?.removeActionForKey("wSound")
            firstBody.node?.userInteractionEnabled = false
            firstBody.node?.runAction(bombWalk)
            firstBody.node?.runAction(rseq)
            
            //            firstBody.node?.physicsBody?.applyImpulse(CGVector(
            //                dx: CGFloat(2),
            //                dy: CGFloat(2)))
            
        }
        
    
    }

    
   
    // Update function for each frame
     override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
//        if bomb.texture == "ex6.png"{
//            self.scene?.view?.paused = true
//            score.text = "game over"
//        
//        }
        
        // Keeps background image in place
        bg.size = self.frame.size
        bg.userInteractionEnabled = false
        bg.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))

    }
    
    
  
}
