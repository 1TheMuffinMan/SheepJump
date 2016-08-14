//
//  Sheep.swift
//  SheepJump
//
//  Created by Nicholas Lechnowskyj on 2/13/16.
//  Copyright © 2016 Njl. All rights reserved.
//

import SpriteKit

class Sheep : SKSpriteNode, GameSprite {
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize?) {
        self.texture = SKTexture(imageNamed: "Sheep")
        self.zPosition = 3
        self.name = "Sheep"
        self.position = position
        self.size = size != nil ? size! : (self.texture?.size())!
        self.physicsBody =  SKPhysicsBody(texture: self.texture!, alphaThreshold: 0, size: self.size)
          //  SKPhysicsBody(circleOfRadius: 42)
        self.physicsBody?.categoryBitMask = PhysicsCategory.sheep.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.raft.rawValue | PhysicsCategory.rightGround.rawValue
        //only collide with the raft
        self.physicsBody?.collisionBitMask = PhysicsCategory.raft.rawValue
        self.physicsBody?.mass = 0.8
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.linearDamping = 0.0;
        
        self.physicsBody?.friction = 1.0
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        parentNode.addChild(self)
        // return
        let right = SKAction.moveToX(CGFloat(130), duration: NSTimeInterval(2.35))
        self.runAction(right, completion: {
            self.physicsBody?.affectedByGravity = true
            self.physicsBody?.applyImpulse(CGVectorMake(150, 400))
            
        })
    }
    
    func bleat() {
        let dice = arc4random_uniform(6)+1
        var fileName = "bleat0\(dice).wav"
        if (dice == 6){
            fileName = "bleat_alt01.wav"
        }
        let soundAction = SKAction.playSoundFileNamed(fileName, waitForCompletion: false)
        self.runAction(soundAction)
    }
    
    func walk(pointsToWalk:UInt, completion: (()-> Void)?) {
        let action = SKAction.moveByX(CGFloat(pointsToWalk), y: 0, duration: 3)
        self.runAction(action, completion: completion!)
    }
}
