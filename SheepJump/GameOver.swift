//
//  GameOver.swift
//  SheepJump
//
//  Created by Nicholas Lechnowskyj on 3/19/16.
//  Copyright © 2016 Njl. All rights reserved.
//

import SpriteKit

class GameOver : SKShapeNode, GameSprite {
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize?) {
        
        let temp = SKShapeNode(rectOfSize: CGSize(width: 200, height: 100))
        
        self.fillColor = UIColor.orangeColor()
        self.path = temp.path
        self.position = CGPointMake(500, 500)
        self.zPosition = 20
        self.strokeColor = UIColor.clearColor()
        
        parentNode.addChild(self)
    }
}
