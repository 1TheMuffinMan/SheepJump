//
//  GameScene.swift
//  SheepJump
//
//  Created by Nicholas Lechnowskyj on 2/10/16.
//  Copyright (c) 2016 Njl. All rights reserved.
//

import SpriteKit
import NotificationCenter
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    let world = SKNode()
    let raft = Raft()
    var selectedNode : SKNode?
    var hud : HUD?
    var sheeps = [SKNode]()
    var lives = 3
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.contactDelegate = self
        scene?.addChild(world)
        scene?.physicsWorld.gravity = CGVector(dx: 0, dy: -10)
        scene?.scaleMode = SKSceneScaleMode.fill;
        /* Setup background */
        let background = SKSpriteNode(imageNamed: "Main Background.png")
        background.zPosition = 1;
        background.size = frame.size;
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        
        world.addChild(background)
        
        //setup water
        Water().spawn(world, position: CGPoint(x: frame.size.width/2, y: 20), size: nil)
        setupGround()
        
        let duration = SKAction.wait(forDuration: Double(Int(arc4random_uniform(3) +  2)))
        let spawn = SKAction.run {
            let sheep = Sheep()
            self.sheeps.append(sheep)
            sheep.spawn(self.world, position: CGPoint(x: -60, y: 500), size: nil)
        }
        
        let sequence = SKAction.sequence([duration, spawn])
        self.run(SKAction.repeatForever(sequence))
        
        raft.spawn(world, position:CGPoint(x: (world.scene?.size.width)!/2, y: 50) , size: CGSize(width: 120, height: 100))
        hud = HUD(parentNode: world, lives: 3)
    }
    
    func setupGround(){
        let leftGround = SKSpriteNode(color: UIColor.green, size: CGSize(width: 200, height: 10))
        leftGround.isHidden = true
        leftGround.position = CGPoint(x: -45, y: 461)
        leftGround.zPosition = 10
        leftGround.anchorPoint = CGPoint(x:0, y:0)
        let pointTopRight = CGPoint(x: leftGround.size.width, y: 0)
        leftGround.physicsBody = SKPhysicsBody(edgeFrom: CGPoint.zero, to: pointTopRight)
        world.addChild(leftGround)
        
        let rightGround = SKSpriteNode(color: UIColor.red, size: CGSize(width: 125, height: 1))
        rightGround.isHidden = true
        rightGround.position = CGPoint(x: (world.scene?.size.width)! - 125, y: 461)
        rightGround.anchorPoint = CGPoint(x: 0, y: 0)
        rightGround.zPosition = 10
        rightGround.physicsBody = SKPhysicsBody(edgeFrom: CGPoint.zero, to: CGPoint(x: rightGround.size.width, y: 0))
        rightGround.physicsBody?.categoryBitMask = PhysicsCategory.rightGround.rawValue
        world.addChild(rightGround)
    }
    
    func splash(){
        let action = SKAction.playSoundFileNamed("water-splash01.wav", waitForCompletion: false)
        self.run(action);
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(selectedNode == nil){
            return
        }
        
        let touch = touches.first
        let location  = touch?.location(in: world)
        let node = selectedNode
        
        let previousLocation = touch!.previousLocation(in: world)
        let diff = location!.x - previousLocation.x;
        let newPosition = CGPoint(x: node!.position.x + diff, y: node!.position.y);
        if(newPosition.x < 163 || newPosition.x > 860){
            return
        }
        node!.position = newPosition;
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let viewTouchLocation = touch.location(in: self.view)
        let sceneTouchPoint = scene?.convertPoint(fromView: viewTouchLocation)
        let touchedNodes = scene?.nodes(at: sceneTouchPoint!)
        for touchedNode in touchedNodes! {
            if(touchedNode == raft){
                selectedNode = raft;
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedNode = nil
    }
    
    override func didSimulatePhysics() {
        //detect if sheep is on ground
        
        for sheep in sheeps {
            if(sheep.position.x > (world.scene?.size.width)! - 125){
                if(sheep.position.y > 461){
                    //add right ground collision
                     sheep.physicsBody?.collisionBitMask |= PhysicsCategory.rightGround.rawValue
                }
                else {
                    //add right ground collision
                      sheep.physicsBody?.collisionBitMask &= ~PhysicsCategory.rightGround.rawValue
                }
            }
            
            //sheep crossed
            if((sheep.position.x - (sheep.frame.size.width/2)) > world.scene?.size.width){
                sheeps.remove(at: sheeps.index(of: sheep)!)
                sheep.removeFromParent()
                self.run(SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false))
                hud?.incrementScore()
                continue
            }
            
            //sheep died
            
            if(sheep.position.x < 30 && sheep.position.y < 460){
                self.run(SKAction.playSoundFileNamed("explosion1.wav", waitForCompletion: false))
                sheepDied(sheep, isWaterDeath: false)
                continue
            }
            
            //water death
            if(sheep.position.y < 20){
                
                sheepDied(sheep, isWaterDeath: true)
            }
        }
    }
    
    func sheepDied(_ sheepNode: SKNode, isWaterDeath: Bool){
        if(isWaterDeath){
        splash()
        }
        sheeps.remove(at: sheeps.index(of: sheepNode)!)
        sheepNode.removeFromParent()
        lives -= 1
        hud?.decrementLives()
        if(lives == 0){
            GameOver().spawn(world, position: CGPoint(x: 100, y: 100), size: CGSize(width: 10, height: 10))
        
            //self.scene?.isPaused = true
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let otherBody :SKPhysicsBody
        let sheepBody : SKPhysicsBody
        
        if ((contact.bodyA.categoryBitMask & PhysicsCategory.sheep.rawValue) > 0){
            otherBody = contact.bodyB
            sheepBody = contact.bodyA
        }
        else {
            otherBody = contact.bodyA
            sheepBody = contact.bodyB
        }
        
        //find the type of contact
        switch otherBody.categoryBitMask {
        case PhysicsCategory.raft.rawValue:
            let sheep = sheepBody.node as! Sheep
            sheep.bleat()
            sheep.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 0))
            
        case PhysicsCategory.rightGround.rawValue:
            //if ground collision is turned on reset the sheeps velocity to stop jumping
            let sheep = sheepBody.node as! Sheep
            if((sheep.physicsBody?.collisionBitMask)! & PhysicsCategory.rightGround.rawValue > 0){
                sheep.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                sheep.walk(200, completion: {sheep.removeFromParent()})
            }
        default:
            break
            //print("no contact")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}

enum PhysicsCategory:UInt32 {
    case sheep = 1
    case raft = 2
    case ground = 4
    case rightGround = 8
}
