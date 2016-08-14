//
//  GameScene.swift
//  SheepJump
//
//  Created by Nicholas Lechnowskyj on 2/10/16.
//  Copyright (c) 2016 Njl. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let world = SKNode()
    let raft = Raft()
    var selectedNode : SKNode?
    var hud : HUD?
    var sheeps = [SKNode]()
    var lives = 3
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.contactDelegate = self
        scene?.addChild(world)
        scene?.physicsWorld.gravity = CGVectorMake(0, -10)
        /* Setup background */
        let background = SKSpriteNode(imageNamed: "Main Background.png")
        background.zPosition = 1;
        background.size = frame.size;
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        
        world.addChild(background)
        
        //setup water
        Water().spawn(world, position: CGPoint(x: frame.size.width/2, y: 20), size: nil)
        setupGround()
        
        let duration = SKAction.waitForDuration(1.5)
        let spawn = SKAction.runBlock {
            let sheep = Sheep()
            self.sheeps.append(sheep)
            sheep.spawn(self.world, position: CGPoint(x: -60, y: 500), size: nil)
        }
        let sequence = SKAction.sequence([duration, spawn])
        self.runAction(SKAction.repeatActionForever(sequence))
        
        raft.spawn(world, position:CGPoint(x: (world.scene?.size.width)!/2, y: 50) , size: CGSize(width: 120, height: 100))
        hud = HUD(parentNode: world, lives: 3)
    }
    
    func setupGround(){
        let leftGround = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: 200, height: 10))
        leftGround.hidden = true
        leftGround.position = CGPoint(x: -45, y: 461)
        leftGround.zPosition = 10
        leftGround.anchorPoint = CGPoint(x:0, y:0)
        let pointTopRight = CGPoint(x: leftGround.size.width, y: 0)
        leftGround.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointZero, toPoint: pointTopRight)
        world.addChild(leftGround)
        
        let rightGround = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(125, 1))
        rightGround.hidden = true
        rightGround.position = CGPointMake((world.scene?.size.width)! - 125, 461)
        rightGround.anchorPoint = CGPointMake(0, 0)
        rightGround.zPosition = 10
        rightGround.physicsBody = SKPhysicsBody(edgeFromPoint: CGPointZero, toPoint: CGPointMake(rightGround.size.width, 0))
        rightGround.physicsBody?.categoryBitMask = PhysicsCategory.rightGround.rawValue
        world.addChild(rightGround)
    }
    
    func splash(){
        let action = SKAction.playSoundFileNamed("water-splash01.wav", waitForCompletion: false)
        self.runAction(action);
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(selectedNode == nil){
            return
        }
        
        let touch = touches.first
        let location  = touch?.locationInNode(world)
        let node = selectedNode
        
        let previousLocation = touch!.previousLocationInNode(world)
        let diff = location!.x - previousLocation.x;
        let newPosition = CGPointMake(node!.position.x + diff, node!.position.y);
        if(newPosition.x < 163 || newPosition.x > 860){
            return
        }
        node!.position = newPosition;
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first!
        let viewTouchLocation = touch.locationInView(self.view)
        let sceneTouchPoint = scene?.convertPointFromView(viewTouchLocation)
        let touchedNodes = scene?.nodesAtPoint(sceneTouchPoint!)
        for touchedNode in touchedNodes! {
            if(touchedNode == raft){
                selectedNode = raft;
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
                sheeps.removeAtIndex(sheeps.indexOf(sheep)!)
                sheep.removeFromParent()
                self.runAction(SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false))
                hud?.incrementScore()
                continue
            }
            
            //sheep died
            
            if(sheep.position.x < 30 && sheep.position.y < 460){
                self.runAction(SKAction.playSoundFileNamed("explosion1.wav", waitForCompletion: false))
                sheepDied(sheep, isWaterDeath: false)
                continue
            }
            
            //water death
            if(sheep.position.y < 20){
                
                sheepDied(sheep, isWaterDeath: true)
            }
        }
    }
    
    func sheepDied(sheepNode: SKNode, isWaterDeath: Bool){
        if(isWaterDeath){
        splash()
        }
        sheeps.removeAtIndex(sheeps.indexOf(sheepNode)!)
        sheepNode.removeFromParent()
        --lives
        hud?.decrementLives()
        if(lives == 0){GameOver().spawn(world, position: CGPointMake(100, 100), size: CGSizeMake(10, 10))
           // self.scene?.paused = true
            
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
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
            sheep.physicsBody?.applyImpulse(CGVectorMake(50, 0))
            
        case PhysicsCategory.rightGround.rawValue:
            //if ground collision is turned on reset the sheeps velocity to stop jumping
            let sheep = sheepBody.node as! Sheep
            if((sheep.physicsBody?.collisionBitMask)! & PhysicsCategory.rightGround.rawValue > 0){
                sheep.physicsBody?.velocity = CGVectorMake(0, 0)
                sheep.walk(200, completion: {sheep.removeFromParent()})
            }
        default:
            break
            //print("no contact")
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

enum PhysicsCategory:UInt32 {
    case sheep = 1
    case raft = 2
    case ground = 4
    case rightGround = 8
}
