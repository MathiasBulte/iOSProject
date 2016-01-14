//
//  GameScene.swift
//  AsteroidsiOS
//
//  Created by Mathias on 10/12/2015.
//  Copyright (c) 2015 Mathias. All rights reserved.
//
import SpriteKit
import Foundation
class GameScene: SKScene, SKPhysicsContactDelegate {
    var viewController: UIViewController?
    let amountOfAsteroids = 2
    let sprite = SKSpriteNode(imageNamed:"Spaceship")
    let missile = SKSpriteNode(imageNamed:"Missile")
    let asteroid = SKSpriteNode(imageNamed:"Asteroid")
    var touching:Bool = false
    var touchPos = CGPointMake(0, 0)
    var timeBeginTouch:CFTimeInterval = 0
    var asteroids:[SKSpriteNode] = []
    var isMissileDestroyed = true
    
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let Ship   : UInt32 = 0b1
        static let Missile: UInt32 = 0b10
        static let Asteroid: UInt32 = 0b11
    }
    
    override func didMoveToView(view: SKView) {
        view.ignoresSiblingOrder = false;
        createShip()
        createMissile()
        spawnAsteroids()
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
    
        
    }
    override func didSimulatePhysics() {
        spawnAsteroids()
    }
    func createShip() {
        sprite.xScale = 0.1
        sprite.yScale = 0.1
        
        sprite.position = CGPoint(x: size.width/2, y: size.height/2)
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width)
        sprite.physicsBody?.dynamic = true
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Ship
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.addChild(sprite)
    }
    func createMissile() {
        missile.setScale(0.05)
        missile.physicsBody = SKPhysicsBody(rectangleOfSize: missile.size)
        missile.physicsBody?.dynamic = true
        missile.physicsBody?.categoryBitMask = PhysicsCategory.Missile
        missile.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid
        missile.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // CACurrentMediaTime gevonden in https://gist.github.com/kristopherjohnson/4201fbe86473f6edb207
        timeBeginTouch = CACurrentMediaTime()
        touching = true
        
        for touch in touches {
            touch.force
            touchPos = touch.locationInNode(self)
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            touchPos = touch.locationInNode(self)
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if CACurrentMediaTime() - timeBeginTouch < CFTimeInterval(0.1) {
            rotateAngleToTouchLocation()
            shootMissile()
        }
        touching = false
    }
   
    
    override func update(currentTime: CFTimeInterval) {
        if CACurrentMediaTime() - timeBeginTouch > CFTimeInterval(0.1) {
            if touching {
                moveShipToTouch()
                rotateAngleToTouchLocation()
            }
        }
    }
    func shootMissile() {
        if isMissileDestroyed {
            isMissileDestroyed = false
            self.addChild(missile)
            missile.position = sprite.position
            
            let pi = CGFloat(M_PI)
            let atan = atan2(sprite.position.y - touchPos.y, sprite.position.x - touchPos.x)
            let angleOffset = CGFloat(0.5)
            let degrees = atan + (pi * angleOffset)
            let rotate = SKAction.rotateToAngle(degrees, duration: 0.0)
            
            let missileVelocity = self.frame.size.width / 3.0
            
            let moveDifference = CGPointMake(touchPos.x - missile.position.x, touchPos.y - missile.position.y)
            let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
            
            let moveDuration = distanceToMove / missileVelocity
            
            let moveAction = SKAction.moveTo(touchPos, duration: NSTimeInterval(moveDuration))
            
            missile.runAction(rotate)
            missile.runAction(moveAction, completion: {
                self.missile.removeFromParent()
                self.isMissileDestroyed = true
            })
        }
        
        
    }
    func rotateAngleToTouchLocation() {
        
        /*
            Berekenen van de hoek tussen 2 punten gebaseerd op: 
            http://www.gamedev.net/topic/549373-calculating-the-angle-between-2-points-in-a-2d-system/
            Interessante link die ik uiteindelijk niet nodig had omdat ik een duration van 0.0 gebruik, 
            ivm de uitkomst van atan2 die -180 -> 0 is of 0 -> 180
            http://stackoverflow.com/questions/1311049/how-to-map-atan2-to-degrees-0-360
        */
        let pi = CGFloat(M_PI)
        let atan = atan2(sprite.position.y - touchPos.y, sprite.position.x - touchPos.x)
        let angleOffset = CGFloat(0.5)
        let degrees = atan + (pi * angleOffset)
        let rotate = SKAction.rotateToAngle(degrees, duration: 0.0)
        
        sprite.runAction(rotate)
    }
    func moveShipToTouch() {
        
        let speed = 3 as CGFloat

        var dx = touchPos.x - sprite.position.x
        var dy = touchPos.y - sprite.position.y
        let mag = sqrt(dx*dx+dy*dy)
        dx = dx/mag * speed
        dy = dy/mag * speed
        
        
        let distance = SDistanceBetweenPoints(touchPos, second: sprite.position)
        // Als de afstand te klein is, faalt de bovenstaande berekening van de positie, bij een afstand
        // groter dan 5 werkt deze perfect en voelt het ook responsief voor de gebruiker
        // (afstanden kleiner dan 5 gebeuren alleen wanneer de touch op het schip zelf is)
        if distance > 5 {
            sprite.position = CGPointMake(sprite.position.x+dx, sprite.position.y+dy)
        }
    }
    func spawnAsteroids() {
        for var index = 0; index < amountOfAsteroids - asteroids.count; ++index {
            let spawnedAsteroid:SKSpriteNode = SKSpriteNode(imageNamed: "Asteroid")
            spawnedAsteroid.position = generatePosition()
            spawnedAsteroid.setScale(0.5)
            spawnedAsteroid.physicsBody = SKPhysicsBody(circleOfRadius: spawnedAsteroid.size.width/2)
            spawnedAsteroid.physicsBody?.dynamic = true
            spawnedAsteroid.physicsBody?.categoryBitMask = PhysicsCategory.Asteroid
            spawnedAsteroid.physicsBody?.contactTestBitMask = PhysicsCategory.Ship
            spawnedAsteroid.physicsBody?.collisionBitMask = PhysicsCategory.None
            scene!.addChild(spawnedAsteroid)
            let moveAction = SKAction.moveTo(
                CGPoint(
                x: size.width - spawnedAsteroid.position.x,
                y: size.height - spawnedAsteroid.position.y), duration: NSTimeInterval(Int(arc4random_uniform(5) + 6)))
            
            spawnedAsteroid.runAction(moveAction, completion: {
                spawnedAsteroid.removeFromParent()
                self.asteroids.removeAtIndex(self.asteroids.indexOf(spawnedAsteroid)!)
            })
            
            asteroids.append(spawnedAsteroid)
        }
    }
    func generatePosition() -> CGPoint {
        let xOrY:UInt32 = arc4random_uniform(2)
        if xOrY == 0 {
            // X axis spawn
            return CGPoint(x: 100, y: Int(arc4random_uniform(UInt32(size.height))))
        } else {
            // Y axis spawn
            return CGPoint(x: Int(arc4random_uniform(UInt32(size.width))), y: 0)
        }
    }
    func SDistanceBetweenPoints(first:CGPoint, second:CGPoint)->CGFloat {
        /*
            Functie gevonden op:
            http://stackoverflow.com/questions/21251706/ios-spritekit-how-to-calculate-the-distance-between-two-nodes
            Maar was in Objective-C dus heb ik ze omgezet naar Swift.
        */
        return CGFloat(hypotf(Float(second.x - first.x), Float(second.y - first.y)));
    }
    func didBeginContact(contact: SKPhysicsContact) {
        /*
            Collision detection: http://www.raywenderlich.com/119815/sprite-kit-swift-2-tutorial-for-beginners
        */
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask == PhysicsCategory.Ship) &&
            (secondBody.categoryBitMask == PhysicsCategory.Asteroid)) {
                gameOver()
        }
        if ((firstBody.categoryBitMask == PhysicsCategory.Missile) &&
            (secondBody.categoryBitMask == PhysicsCategory.Asteroid)) {
                projectileDidCollideWithAsteroid(firstBody.node as! SKSpriteNode, asteroid: secondBody.node as! SKSpriteNode)
        }
        
    }
    func gameOver() {
        scene!.view!.paused = true
        self.viewController?.performSegueWithIdentifier("gameOverSegue", sender: self)
        
        //GameViewController().gameOver()

    }
    func projectileDidCollideWithAsteroid(projectile:SKSpriteNode, asteroid:SKSpriteNode) {
        self.asteroids.removeAtIndex(self.asteroids.indexOf(asteroid)!)
        asteroid.removeFromParent()
    }

}
