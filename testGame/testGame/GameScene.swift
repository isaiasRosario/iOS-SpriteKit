
import SpriteKit
import AVFoundation


// Vector addition
private func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

// Vector subtraction
private func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

// Vector * scalar
private func *(point: CGPoint, factor: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * factor, y:point.y * factor)
}

private extension CGPoint {

    var length: CGFloat { return sqrt(self.x * self.x + self.y * self.y) }

    var normalized: CGPoint { return CGPoint(x: self.x / self.length, y: self.y / self.length) }
}



class GameScene: SKScene, SKPhysicsContactDelegate {


    var backgroundMusicPlayer: AVAudioPlayer!

    private var lastUpdateTime: CFTimeInterval = 0
    private var timeSinceLastShipSpawned: CFTimeInterval  = 0
    

    private let cannon = SKSpriteNode(imageNamed: "cannon")
    

    private let ballCategory: UInt32 = 0x1 << 0   // 00000000000000000000000000000001 in binary
    private let shipCategory: UInt32   = 0x1 << 1   // 00000000000000000000000000000010 in binary
    
    

    override func didMoveToView(view: SKView) {

        var error: NSError?
        let backgroundMusicURL = NSBundle.mainBundle().URLForResource("background-music", withExtension: "mp3")
        backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL, error: &error)
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
        
        backgroundColor = SKColor(red: 0, green: 0.1, blue: 1, alpha: 1)
        
        cannon.setScale(0.60)
        cannon.position = CGPoint(x: size.width / 2, y: cannon.size.height * 1.75)
        addChild(cannon)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        spawnShip()
    }
    

    override func update(currentTime: CFTimeInterval) {
        var timeSinceLastUpdate = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if timeSinceLastUpdate > 1 {
            timeSinceLastUpdate = 1.0 / 60.0
            lastUpdateTime = currentTime
        }
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
    }
    

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        
        
        let targetingVector = touchLocation - cannon.position
        if targetingVector.y > 0 {
          
            fireCannon(targetingVector)
        }
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody!
        var secondBody: SKPhysicsBody!
        
       
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & ballCategory) != 0 &&
            (secondBody.categoryBitMask & shipCategory) != 0 {
                
                runAction(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false))
                let ball = firstBody.node as! SKSpriteNode
                let ship = secondBody.node as! SKSpriteNode
                
                ball.removeFromParent()
                ship.removeFromParent()
        }
    }
    
    
    func updateWithTimeSinceLastUpdate(timeSinceLastUpdate: CFTimeInterval) {
        
        timeSinceLastShipSpawned += timeSinceLastUpdate
        if (timeSinceLastShipSpawned > 0.5) {
            timeSinceLastShipSpawned = 0
            spawnShip()
        }
    }
    
    func spawnShip() {
        
        enum Direction {
            case GoingRight
            case GoingLeft
        }
        
        var shipDirection: Direction!
        var shipSpriteImage: String!
        
        if Int(arc4random_uniform(2)) == 0 {
            shipDirection = Direction.GoingRight
            shipSpriteImage = "ship-right"
        }
        else {
            shipDirection = Direction.GoingLeft
            shipSpriteImage = "ship-left"
        }
        
        let ship = SKSpriteNode(imageNamed: shipSpriteImage)
        

        ship.physicsBody = SKPhysicsBody(rectangleOfSize: ship.size)
        ship.physicsBody?.dynamic = true
        ship.physicsBody?.categoryBitMask = shipCategory
        ship.physicsBody?.contactTestBitMask = ballCategory
        ship.physicsBody?.collisionBitMask = 0
        

        var shipSpawnX: CGFloat!
        var shipEndX: CGFloat!
        if shipDirection == Direction.GoingRight {
            shipSpawnX = -(ship.size.width / 2)
            shipEndX = frame.size.width + (ship.size.width / 2)
        }
        else {
            shipSpawnX = frame.size.width + (ship.size.width / 2)
            shipEndX = -(ship.size.width / 2)
        }
        let minSpawnY = frame.size.height / 3
        let maxSpawnY = (frame.size.height * 0.9) - ship.size.height / 2
        let spawnYRange = UInt32(maxSpawnY - minSpawnY)
        let shipSpawnY = CGFloat(arc4random_uniform(spawnYRange)) + minSpawnY
        ship.position = CGPoint(x: shipSpawnX, y: shipSpawnY)
        
        addChild(ship)
        
        let minMoveTime = 3
        let maxMoveTime = 6
        let moveTimeRange = maxMoveTime - minMoveTime
        let moveTime = NSTimeInterval((Int(arc4random_uniform(UInt32(moveTimeRange))) + minMoveTime))
        
        
        let moveAction = SKAction.moveToX(shipEndX, duration: moveTime)
        let cleanUpAction = SKAction.removeFromParent()
        ship.runAction(SKAction.sequence([moveAction, cleanUpAction]))
    }
    
    func fireCannon(targetingVector: CGPoint) {
        
    
        runAction(SKAction.playSoundFileNamed("ball.mp3", waitForCompletion: false))
        
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.position.x = cannon.position.x
        ball.position.y = cannon.position.y + (cannon.size.height / 2)
        
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask  = shipCategory
        ball.physicsBody?.collisionBitMask = 0
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(ball)
        
        
        let direction = targetingVector.normalized
        let ballVector = direction * 1000
        let ballEndPos = ballVector + ball.position
        let ballSpeed: CGFloat = 500
        let ballMoveTime = size.width / ballSpeed
        
        
        let actionMove = SKAction.moveTo(ballEndPos, duration: NSTimeInterval(ballMoveTime))
        let actionMoveDone = SKAction.removeFromParent()
        ball.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    
}