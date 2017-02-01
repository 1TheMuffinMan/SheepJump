//
//  Water.swift
//  SheepJump
//
//  Created by Nicholas Lechnowskyj on 2/14/16.
//  Copyright © 2016 Njl. All rights reserved.
//

import SpriteKit

class Water : SKSpriteNode, GameSprite {
    func spawn(_ parentNode: SKNode, position: CGPoint, size: CGSize?) {
        self.texture = SKTexture(imageNamed: "Water-fg")
        self.zPosition = 10
        self.position = position
        self.size = (self.texture?.size())!
        
        //animate
        let interval = TimeInterval(4)
        let left = SKAction.moveTo(x: CGFloat(((parentNode.scene?.size.width)!/2)-50), duration: interval)
        let right = SKAction.moveTo(x: CGFloat(((parentNode.scene?.size.width)!/2) + 50), duration: interval)
        let action = SKAction.repeatForever(SKAction.sequence([left,right]))
        self.run(action)
        
        parentNode.addChild(self)
    }
}
