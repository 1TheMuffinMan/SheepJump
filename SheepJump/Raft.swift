//
//  Raft.swift
//  SheepJump
//
//  Created by Nicholas Lechnowskyj on 2/13/16.
//  Copyright © 2016 Njl. All rights reserved.
//

import SpriteKit

class Raft : SKSpriteNode, GameSprite {
    func spawn(_ parentNode: SKNode, position: CGPoint, size: CGSize?) {
      
        //texture = SKTexture(imageNamed: "Sheep")
        self.color = UIColor.red
        
        self.zPosition = 5
        self.name = "Raft"
        self.size = size!
        self.position = position
        //collision
        let pointTopRight = CGPoint(x: size!.width, y: 0)
        self.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -(self.size.width/2), y: 0), to: pointTopRight)
        self.physicsBody?.categoryBitMask = PhysicsCategory.raft.rawValue
        
        parentNode.addChild(self)
        
        
    }
}
