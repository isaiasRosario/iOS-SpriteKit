//
//  GameScene.swift
//  BombPanic
//
//  Created by Isaias Rosario on 7/31/15.
//  Copyright (c) 2015 Isaias Rosario. All rights reserved.
//

import SpriteKit
import SceneKit
import AVFoundation


// Physic Categories for Sprites
struct PhysicsCategory {
    static let Bomb       : UInt32 = 0x1 << 0
    static let Wall       : UInt32 = 0x2 << 1
    static let None       : UInt32 = 0x3 << 2
    static let blueFloor  : UInt32 = 0x4 << 3
    static let blackFloor : UInt32 = 0x5 << 4
    static let Bomb2      : UInt32 = 0x6 << 5
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Global Variables
    var bg: SKSpriteNode!
    var cage: SKSpriteNode!
    var bomb: SKSpriteNode!
    var bombWalk: SKAction!
    var bombExp: SKAction!
    var bombWalk2: SKAction!
    var seqExp: SKAction!
    var pause: SKSpriteNode!
    var timer: SKSpriteNode!
    var bgMP: AVAudioPlayer!
    var count = 0
    let score = SKLabelNode(fontNamed:"Chalkduster-Bold")
    var spark: SKEmitterNode!
    var smoke: SKEmitterNode!
    
    var timerCount = 1.5
    
    var bool = true
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Cage floor set up
        let blackFloor = childNodeWithName("blackFloor")
        blackFloor?.userInteractionEnabled = false
        blackFloor?.physicsBody?.categoryBitMask = PhysicsCategory.blackFloor
        blackFloor?.physicsBody?.collisionBitMask = PhysicsCategory.Bomb
        blackFloor?.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb
        
        let blueFloor = childNodeWithName("blueFloor")
        blueFloor?.userInteractionEnabled = false
        blueFloor?.physicsBody?.categoryBitMask = PhysicsCategory.blueFloor
        blueFloor?.physicsBody?.collisionBitMask = PhysicsCategory.Bomb
        blueFloor?.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb

        
        // Socre label set up
        score.text = "0"
        score.fontSize = 75
        score.zPosition = 3.0
        score.position = CGPoint(x:65, y:CGRectGetMidY(self.frame)+195)
        self.addChild(score)
        
        // Pause button set up
        pause = SKSpriteNode(imageNamed: "pause.png")
        pause.name = "pause"
        pause.zPosition = 3.0
        pause.yScale = 0.3
        pause.xScale = 0.3
        pause.position = CGPoint(x:CGRectGetMidX(self.frame)+420, y:CGRectGetMidY(self.frame)+220)
        self.addChild(pause)
        
        // Timer sprite button
        timer = SKSpriteNode(imageNamed: "timer.png")
        timer.name = "timer"
        timer.zPosition = 3.0
        timer.yScale = 0.3
        timer.xScale = 0.3
        timer.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        timer.hidden = true
        self.addChild(timer)
 
        // Setup background image for game secene
        bg = SKSpriteNode(imageNamed: "bg.jpg")
        bg.size = self.frame.size
        bg.userInteractionEnabled = false
        bg.zPosition = 0.0
        bg.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(bg)
        
        // Setup for background music loop
        var error: NSError?
        let backgroundMusicURL = NSBundle.mainBundle().URLForResource("bg", withExtension: "wav")
        bgMP = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error: &error)
        bgMP.numberOfLoops = -1
        bgMP.prepareToPlay()
        bgMP.volume = 0.15
        bgMP.play()
        
        // Setup to make screen edges act like a wall using physics body
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame.standardizedRect)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        self.physicsBody?.collisionBitMask = PhysicsCategory.Bomb
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        self.physicsWorld.contactDelegate = self;
        self.physicsBody?.friction = 0.0
        
        // Bomb explosion set up
        let atlasEx = SKTextureAtlas(named: "explode")
        let expS = SKAction.playSoundFileNamed("explode.wav", waitForCompletion: false)
        
        let expl = SKAction.animateWithTextures([
            atlasEx.textureNamed("ex1.png"),
            atlasEx.textureNamed("ex2.png"),
            atlasEx.textureNamed("ex3.png"),
            atlasEx.textureNamed("ex4.png"),
            atlasEx.textureNamed("ex5.png"),
            atlasEx.textureNamed("ex6.png")
            ], timePerFrame: 0.09)
        
        let blow = SKAction.scaleBy(1.5, duration: 0.5)
        let end = SKAction.playSoundFileNamed("end.wav", waitForCompletion: false)
        
        bombExp = SKAction.sequence([blow, expS, expl, end])
        
        // Add bombs to scene every 2 seconds
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(setupBomb),
                SKAction.waitForDuration(timerCount)
                ])
            ), withKey: "bombSetup")
        
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

        
        // Atlas for bomb animation setup
        let atlas = SKTextureAtlas(named: "bomb")
        
        let anim = SKAction.animateWithTextures([
            atlas.textureNamed("sprite_left_1.png"),
            atlas.textureNamed("sprite_left_2.png"),
            atlas.textureNamed("sprite_left_3.png"),
            atlas.textureNamed("sprite_left_4.png")
            ], timePerFrame: 0.09)
        
        let anim2 = SKAction.animateWithTextures([
            atlas.textureNamed("blue_sprite_left_1.png"),
            atlas.textureNamed("blue_sprite_left_2.png"),
            atlas.textureNamed("blue_sprite_left_3.png"),
            atlas.textureNamed("blue_sprite_left_4.png")
            ], timePerFrame: 0.09)
        
        let array = [1, 2]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        
        let num = array[randomIndex]
        
        if num == 1{
            bombWalk = SKAction.repeatActionForever(anim)
            bomb = Bomb(imageNamed: "sprite_left_1.png")
            bomb.name = "bomb"
            bomb.runAction(bombWalk)
        
        }else{
            bombWalk2 = SKAction.repeatActionForever(anim2)
            bomb = Bomb(imageNamed: "blue_sprite_left_1.png")
            bomb.name = "bomb2"
            bomb.runAction(bombWalk2)
        }
        
        // Bomb sprite node property set up
        
        bomb.yScale = 2
        bomb.xScale = 2
        bomb.zPosition = 2.0
        bomb.position = CGPoint(x: CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame)+300)
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: (bomb.size.width / 2) )
        bomb.physicsBody?.dynamic = true
        bomb.physicsBody?.restitution = 1
        bomb.physicsBody?.friction = 0.0
        bomb.physicsBody?.linearDamping = 0.0
        bomb.physicsBody?.velocity = CGVector(dx: random(min: -100, max: 100),dy: -100)
        bomb.physicsBody?.categoryBitMask = PhysicsCategory.Bomb
        bomb.physicsBody?.collisionBitMask = PhysicsCategory.Bomb | PhysicsCategory.Wall
        bomb.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb | PhysicsCategory.Wall

        
        spark = SKEmitterNode(fileNamed: "spark.sks")
        smoke = SKEmitterNode(fileNamed: "smoke.sks")
        smoke.targetNode = self
        spark.position = CGPoint(x: bomb.size.width/2-32,y:bomb.size.height/2-26)
        smoke.position = CGPoint(x: bomb.size.width/2-32,y:bomb.size.height/2-26)
        smoke.zPosition = 2.0
        spark.zPosition = 2.0
        
        bomb.addChild(smoke)
        bomb.addChild(spark)
        
        self.addChild(bomb)
        
        
        // Walking sound for bombs
        let sound = SKAction.playSoundFileNamed("fuse.mp3", waitForCompletion: true)
        let wSound = SKAction.repeatActionForever(sound)
        
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
        seqExp = SKAction.sequence([SKAction.waitForDuration(10), blowUp, expSound, exp, rem])
        
        bomb.runAction(wSound, withKey: "wSound")
        
        bomb.runAction(seqExp, completion: {

            self.bgMP.pause()
            self.bomb.removeFromParent()
            
            var secondScene = SecondScene(size: self.size)
            var transition = SKTransition.flipVerticalWithDuration(1.0)
            secondScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(secondScene, transition: transition)
            
        })
        
        
    }
    
    // bottom bomb set up
    func setupBomb2(){
        
        // Play sound when sprite has spawned
        runAction(SKAction.playSoundFileNamed("spawn.wav", waitForCompletion: false))
        
        
        // Atals for bomb animation setup
        let atlas = SKTextureAtlas(named: "bomb")
        
        let anim = SKAction.animateWithTextures([
            atlas.textureNamed("sprite_left_1.png"),
            atlas.textureNamed("sprite_left_2.png"),
            atlas.textureNamed("sprite_left_3.png"),
            atlas.textureNamed("sprite_left_4.png")
            ], timePerFrame: 0.09)
        
        let anim2 = SKAction.animateWithTextures([
            atlas.textureNamed("blue_sprite_left_1.png"),
            atlas.textureNamed("blue_sprite_left_2.png"),
            atlas.textureNamed("blue_sprite_left_3.png"),
            atlas.textureNamed("blue_sprite_left_4.png")
            ], timePerFrame: 0.09)
        
        let array = [1, 2]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        
        let num = array[randomIndex]
        
        if num == 1{
            bombWalk = SKAction.repeatActionForever(anim)
            bomb = Bomb(imageNamed: "sprite_left_1.png")
            bomb.name = "bomb"
            bomb.runAction(bombWalk)
            
        }else{
            bombWalk2 = SKAction.repeatActionForever(anim2)
            bomb = Bomb(imageNamed: "blue_sprite_left_1.png")
            bomb.name = "bomb2"
            bomb.runAction(bombWalk2)
        }
        
        // Bomb sprite node property set up
        
        bomb.yScale = 2
        bomb.xScale = 2
        bomb.zPosition = 2.0
        bomb.position = CGPoint(x: CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame)-300)
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: (bomb.size.width / 2) )
        bomb.physicsBody?.dynamic = true
        bomb.physicsBody?.restitution = 1
        bomb.physicsBody?.friction = 0.0
        bomb.physicsBody?.linearDamping = 0.0
        bomb.physicsBody?.velocity = CGVector(dx: random(min: -100, max: 100),dy: 100)
        bomb.physicsBody?.categoryBitMask = PhysicsCategory.Bomb
        bomb.physicsBody?.collisionBitMask = PhysicsCategory.Bomb | PhysicsCategory.Wall
        bomb.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb | PhysicsCategory.Wall
        
        
        spark = SKEmitterNode(fileNamed: "spark.sks")
        smoke = SKEmitterNode(fileNamed: "smoke.sks")
        smoke.targetNode = self
        spark.position = CGPoint(x: bomb.size.width/2-32,y:bomb.size.height/2-26)
        smoke.position = CGPoint(x: bomb.size.width/2-32,y:bomb.size.height/2-26)
        smoke.zPosition = 2.0
        spark.zPosition = 2.0
        
        bomb.addChild(smoke)
        bomb.addChild(spark)
        
        self.addChild(bomb)
        
        
        // Walking sound for bombs
        let sound = SKAction.playSoundFileNamed("fuse.mp3", waitForCompletion: true)
        let wSound = SKAction.repeatActionForever(sound)
        
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
        seqExp = SKAction.sequence([SKAction.waitForDuration(5), blowUp, expSound, exp, rem])
        
        bomb.runAction(wSound, withKey: "wSound")
        
        bomb.runAction(seqExp, completion: {
            
            self.bgMP.pause()
            self.bomb.removeFromParent()
            
            var secondScene = SecondScene(size: self.size)
            var transition = SKTransition.flipVerticalWithDuration(1.0)
            secondScene.scaleMode = SKSceneScaleMode.AspectFill
            
            var defaults = NSUserDefaults.standardUserDefaults()
            
            defaults.setObject(self.count, forKey : "Score")
            
            self.scene!.view?.presentScene(secondScene, transition: transition)
            
        })
        
        
    }
    
    // Check to see when touches have began on screen
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch in (touches as! Set<UITouch>) {
            
            // Set sprite touch location
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            let pause = SKLabelNode()
            
            // Check to see what node button was touched
            if touchedNode.name == "pause"{
                // Pause button

                if self.scene?.view?.paused == true{
                    bgMP.play()
                    self.scene?.view?.paused = false
                }else if self.scene?.view?.paused == false{
                    bgMP.pause()
                    self.scene?.view?.paused = true
                }
            }
            
            if (touchedNode.name == "retry") {
                //retry button
                var gameScene = GameScene(fileNamed: "GameScene")
                gameScene.size = self.size
                var transition = SKTransition.doorsCloseHorizontalWithDuration(0.5)
                gameScene.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view?.presentScene(gameScene, transition: transition)
            }
            
            
            // Check to see if timer node was touched
            if (touchedNode.name == "timer") {
                
                // FEATURE ITEM ##--3--## //
                // Stops actions on bombs in scene then resumes back in 10 seconds
                //
                //
                
                bool = false
                
                self.physicsWorld.speed = 0
                println(self.physicsWorld.speed)
                removeActionForKey("bombSetup")
                removeActionForKey("bombSetup2")
                timer.hidden = true
                
                var wait = SKAction.waitForDuration(10)
                var run = SKAction.runBlock {
                    self.physicsWorld.speed = 1
                    println(self.physicsWorld.speed)
                    self.bool = true
                    
                    self.runAction(SKAction.sequence([
                        SKAction.waitForDuration(self.timerCount),
                        SKAction.repeatActionForever(
                            SKAction.sequence([
                                SKAction.runBlock(self.setupBomb),
                                SKAction.waitForDuration(self.timerCount)
                                ])
                        )]), withKey: "bombSetup")
                    self.runAction(SKAction.sequence([
                        SKAction.waitForDuration(self.timerCount),
                        SKAction.repeatActionForever(
                            SKAction.sequence([
                                SKAction.runBlock(self.setupBomb2),
                                SKAction.waitForDuration(self.timerCount)
                                ])
                        )]), withKey: "bombSetup2")
                }
                runAction(SKAction.sequence([wait, run]))
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
            
            if firstBody.velocity.dx >= 0 {
                
                firstBody.velocity = CGVector(dx: random(min: -100, max: 100),dy: -100)
            }
            else{
                firstBody.velocity = CGVector(dx: random(min: -100, max: 100),dy: 100)
            }
            
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            
            if firstBody.velocity.dx >= 0 {
                
                firstBody.velocity = CGVector(dx: -random(min: -100, max: 100),dy: -100)
            }
            else{
                firstBody.velocity = CGVector(dx: random(min: -100, max: 100),dy: 100)
        
            }
            
        }
        
        // Check to see which physics categories have contaced
        if firstBody.categoryBitMask == PhysicsCategory.Bomb && secondBody.categoryBitMask == PhysicsCategory.Bomb{
            println("Bomb Hit Bomb.")
        }
        
        // Check to see if sprite node hit the wall
        if firstBody.categoryBitMask == PhysicsCategory.Bomb && secondBody.categoryBitMask == PhysicsCategory.Wall {
            runAction(SKAction.playSoundFileNamed("bump.wav", waitForCompletion: false))
            println("Bomb Hit The Wall.")
        }
        
        // Check to see if bomb is on the cage
        if firstBody.categoryBitMask == PhysicsCategory.Bomb && secondBody.categoryBitMask == PhysicsCategory.blackFloor{
            
            if firstBody.node?.name == "bomb"{
                let remove = SKAction.sequence([SKAction.waitForDuration(5), SKAction.removeFromParent()])
                
                firstBody.node?.removeAllActions()
                firstBody.node?.removeActionForKey("wSound")
                firstBody.node?.removeAllChildren()
                firstBody.node?.userInteractionEnabled = false
                firstBody.node?.runAction(bombWalk)
                firstBody.node?.runAction(remove)
                runAction(SKAction.playSoundFileNamed("drop.wav", waitForCompletion: false))
                
                
                count = count+1
                score.text = String(count)
                
                // FEATURE ITEM ##--1 and 2--## //
                // #1 Adds bombs at fater rate after a certain score
                // #2 Add more bombs from the bottom up as the score goes up
                //
                //
                if count == 5{
                    
                    timerCount == 1.4
                    
                    removeActionForKey("bombSetup")
                    runAction(SKAction.sequence([
                        SKAction.waitForDuration(timerCount),
                        SKAction.repeatActionForever(
                            SKAction.sequence([
                                SKAction.runBlock(setupBomb),
                                SKAction.waitForDuration(timerCount)
                                ])
                        )]), withKey: "bombSetup")
                    
                    println("Seconds 1.0")
                    
                }else if count == 10{
                    
                    timerCount = 1.35
                    timer.hidden = false
                    
                    removeActionForKey("bombSetup")
                    runAction(SKAction.sequence([
                        SKAction.waitForDuration(timerCount),
                        SKAction.repeatActionForever(
                            SKAction.sequence([
                                SKAction.runBlock(setupBomb),
                                SKAction.waitForDuration(timerCount)
                                ])
                        )]), withKey: "bombSetup")
                    runAction(SKAction.sequence([
                        SKAction.waitForDuration(timerCount),
                        SKAction.repeatActionForever(
                            SKAction.sequence([
                                SKAction.runBlock(setupBomb2),
                                SKAction.waitForDuration(timerCount)
                                ])
                        )]), withKey: "bombSetup2")
                    println("Seconds 0.5")
                    
                }else if count == 50{
                    
                    timerCount = 1.2
                    timer.hidden = false
                    
                    removeActionForKey("bombSetup")
                    removeActionForKey("bombSetup2")
                    runAction(SKAction.sequence([
                        SKAction.waitForDuration(timerCount),
                        SKAction.repeatActionForever(
                            SKAction.sequence([
                                SKAction.runBlock(setupBomb),
                                SKAction.waitForDuration(timerCount)
                                ])
                        )]), withKey: "bombSetup")
                    runAction(SKAction.sequence([
                        SKAction.waitForDuration(timerCount),
                        SKAction.repeatActionForever(
                            SKAction.sequence([
                                SKAction.runBlock(setupBomb2),
                                SKAction.waitForDuration(timerCount)
                                ])
                        )]), withKey: "bombSetup2")
                    
                    println("Seconds 0.1")
                }
                
                println("Black Bomb Has Been Defused!")
                

            }else{
                firstBody.node?.runAction(bombExp, completion: {
                    
                    self.bgMP.pause()
                  
                    var secondScene = SecondScene(size: self.size)
                    var transition = SKTransition.flipVerticalWithDuration(1.0)
                    secondScene.scaleMode = SKSceneScaleMode.AspectFill
                    
                    var defaults = NSUserDefaults.standardUserDefaults()
                    
                    defaults.setObject(self.count, forKey : "Score")
                    
                    self.scene!.view?.presentScene(secondScene, transition: transition)
                    
                })
                
                println("Wrong Bomb!")
            }
            
 
        }
        
        if firstBody.categoryBitMask == PhysicsCategory.Bomb && secondBody.categoryBitMask == PhysicsCategory.blueFloor{
            
            
            if firstBody.node?.name == "bomb2"{
                let remove = SKAction.sequence([SKAction.waitForDuration(5), SKAction.removeFromParent()])
                
                firstBody.node?.removeAllActions()
                firstBody.node?.removeActionForKey("wSound")
                firstBody.node?.removeAllChildren()
                firstBody.node?.userInteractionEnabled = false
                firstBody.node?.runAction(bombWalk2)
                firstBody.node?.runAction(remove)
                runAction(SKAction.playSoundFileNamed("drop.wav", waitForCompletion: false))
                
                
                count = count+1
                score.text = String(count)
                
                // FEATURE ITEM ##--1 and 2--## //
                // #1 Adds bombs at fater rate after a certain score
                // #2 Add more bombs from the bottom up as the score goes up
                //
                //
                if count == 5{
                    
                    timerCount = 1.4
                    
                    removeActionForKey("bombSetup")
                    runAction(SKAction.sequence([
                        SKAction.waitForDuration(timerCount),
                        SKAction.repeatActionForever(
                            SKAction.sequence([
                                SKAction.runBlock(setupBomb),
                                SKAction.waitForDuration(timerCount)
                                ])
                        )]), withKey: "bombSetup")
                    
                    println("Seconds 1.0")
                    
                }else if count == 10{
                    
                    timerCount = 1.35
                    timer.hidden = false
                    
                    removeActionForKey("bombSetup")
                    runAction(SKAction.sequence([
                        SKAction.waitForDuration(timerCount),
                        SKAction.repeatActionForever(
                            SKAction.sequence([
                                SKAction.runBlock(setupBomb),
                                SKAction.waitForDuration(timerCount)
                                ])
                        )]), withKey: "bombSetup")
                    runAction(SKAction.sequence([
                        SKAction.waitForDuration(timerCount),
                        SKAction.repeatActionForever(
                            SKAction.sequence([
                                SKAction.runBlock(setupBomb2),
                                SKAction.waitForDuration(timerCount)
                                ])
                        )]), withKey: "bombSetup2")
                    
                    println("Seconds 0.5")
                    
                }else if count == 50{
                    
                    timerCount = 1.2
                    timer.hidden = false
                    
                    removeActionForKey("bombSetup")
                    removeActionForKey("bombSetup2")
                    runAction(SKAction.sequence([
                        SKAction.waitForDuration(timerCount),
                        SKAction.repeatActionForever(
                            SKAction.sequence([
                                SKAction.runBlock(setupBomb),
                                SKAction.waitForDuration(timerCount)
                                ])
                        )]), withKey: "bombSetup")
                    runAction(SKAction.sequence([
                        SKAction.waitForDuration(timerCount),
                        SKAction.repeatActionForever(
                            SKAction.sequence([
                                SKAction.runBlock(setupBomb2),
                                SKAction.waitForDuration(timerCount)
                                ])
                        )]), withKey: "bombSetup2")
                    
                    println("Seconds 0.1")
                }
                
                println("Blue Bomb Has Been Defused!")
                
            }else{
                firstBody.node?.runAction(bombExp, completion: {
                    
                    self.bgMP.pause()
                
                    var secondScene = SecondScene(size: self.size)
                    var transition = SKTransition.flipVerticalWithDuration(1.0)
                    secondScene.scaleMode = SKSceneScaleMode.AspectFill
                    
                    var defaults = NSUserDefaults.standardUserDefaults()
                    
                    defaults.setObject(self.count, forKey : "Score")
                    
                    self.scene!.view?.presentScene(secondScene, transition: transition)
                    
                })
                
                println("Wrong Bomb!")
            }
            
        }
        
    }
    
    // Update function for each frame
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if bool == false{
            //start enumeration
            self.enumerateChildNodesWithName("*") {
                node, stop in
                //#2
                if let bomb = node as? Bomb {
                    
                    bomb.removeAllActions()
                    
                    //stop.memory = true
                    
                }
        
            }//end enumeration
     
        }
        

        
    }
}
