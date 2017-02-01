//
//  GameOver.swift
//  SheepJump
//
//  Created by Nicholas Lechnowskyj on 3/19/16.
//  Copyright © 2016 Njl. All rights reserved.
//

import SpriteKit

class GameOver : SKShapeNode, GameSprite {
    func spawn(_ parentNode: SKNode, position: CGPoint, size: CGSize?) {
        
        let temp = SKShapeNode(rectOf: CGSize(width: 200, height: 100))
        
        self.fillColor = UIColor.orange
        self.path = temp.path
        self.position = CGPoint(x: 500, y: 500)
        self.zPosition = 20
        self.strokeColor = UIColor.clear
        
        parentNode.addChild(self)
    }
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.fillColor = UIColor.darkGray
    }
}
