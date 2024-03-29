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
 
    var backgroundMusicPlayer: AVAudioPlayer!
    var count = 0
    let score = SKLabelNode(fontNamed:"Chalkduster-Bold")
    var spark: SKEmitterNode!
    var smoke: SKEmitterNode!
    var start = false
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
        
        // Cage floor set up
        let cageFloor = childNodeWithName("cageFloor")
        cageFloor?.userInteractionEnabled = false
        cageFloor?.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        cageFloor?.physicsBody?.collisionBitMask = PhysicsCategory.Bomb
        cageFloor?.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb
        
        
        // Socre label set up
        score.text = "0"
        score.fontSize = 100
        score.zPosition = 3.0
        score.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)+185)
        self.addChild(score)

        
        // Setup background image for game secene
        bg = SKSpriteNode(imageNamed: "bg.jpg")
        bg.size = self.view!.frame.size
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
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame.standardizedRect)
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
        
        let randomNumber = arc4random_uniform(100)
        
        let array = ["bomb", "bomb2"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        print(array[randomIndex])
        
        bomb?.name = array[randomIndex]
        
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
        
        if bomb?.name == "bomb"{
            bombWalk = SKAction.repeatActionForever(anim)
            bomb = Bomb(imageNamed: "blue_sprite_left_1.png")
        }else{
            bombWalk = SKAction.repeatActionForever(anim2)
            bomb = Bomb(imageNamed: "sprite_left_1.png")
        }
        
        
        // Bomb sprite node property set up

        bomb.yScale = 2
        bomb.xScale = 2
        bomb.zPosition = 2.0
        bomb.position = CGPoint(x: CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame)+300)
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: (bomb.size.width / 2) )
        bomb.physicsBody?.categoryBitMask = PhysicsCategory.Bomb
        bomb.physicsBody?.collisionBitMask = PhysicsCategory.Bomb | PhysicsCategory.Wall
        bomb.physicsBody?.contactTestBitMask = PhysicsCategory.Bomb | PhysicsCategory.Wall
        bomb.physicsBody?.dynamic = true
        bomb.physicsBody?.restitution = 1
        bomb.physicsBody?.friction = 0.0
        bomb.physicsBody?.linearDamping = 0.0
        bomb.physicsBody?.velocity = CGVector(dx: random(min: -100, max: 100),dy: -100)
        
        spark = SKEmitterNode(fileNamed: "spark.sks")
        smoke = SKEmitterNode(fileNamed: "smoke.sks")
        smoke.targetNode = self
        spark.position = CGPoint(x: bomb.size.width/2-32,y:bomb.size.height/2-26)
        smoke.position = CGPoint(x: bomb.size.width/2-32,y:bomb.size.height/2-26)
        smoke.zPosition = 1.0
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
        let seqExp = SKAction.sequence([SKAction.waitForDuration(30), blowUp, expSound, exp, rem])

            bomb.runAction(bombWalk)
            bomb.runAction(wSound, withKey: "wSound")
  
            bomb.runAction(seqExp, completion: {
            
            self.backgroundMusicPlayer.pause()
            self.bomb.removeFromParent()
            
            var secondScene = SecondScene(size: self.size)
            var transition = SKTransition.flipVerticalWithDuration(1.0)
            secondScene.scaleMode = SKSceneScaleMode.AspectFill
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
            
            // Check to see if play button was touched to play game
            if touchedNode.name == "play"{
                
                touchedNode.removeFromParent()
                backgroundMusicPlayer.play()
                start = true
                
                runAction(SKAction.repeatActionForever(
                    SKAction.sequence([
                        SKAction.runBlock(setupBomb),
                        SKAction.waitForDuration(2.0)
                        ])
                    ))
                
            }else if touchedNode.name == "pause"{
                // Pause button 
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
            println("You Hit Bomb.")
        }
        
        // Check to see if sprite node hit the wall
        if firstBody.categoryBitMask == PhysicsCategory.Bomb && secondBody.categoryBitMask == PhysicsCategory.Wall {
            runAction(SKAction.playSoundFileNamed("bump.wav", waitForCompletion: false))
            println("Bomb Hit The Wall.")
        }
        
        // Check to see if bomb is on the cage
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
            firstBody.node?.removeAllChildren()
            
        }
    }
   
    // Update function for each frame
     override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        // Keeps background image in place
        bg.size = self.frame.size
        bg.userInteractionEnabled = false
        bg.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))

    }
}
