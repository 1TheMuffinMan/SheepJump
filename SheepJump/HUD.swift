//
//  HUD.swift
//  SheepJump
//
//  Created by Nicholas Lechnowskyj on 2/14/16.
//  Copyright © 2016 Njl. All rights reserved.
//

import SpriteKit

class HUD{
    var livesNode: SKLabelNode
    var currentLives : Int

    var currentScore = 0
    var score:SKLabelNode
    init(parentNode:SKNode, lives: Int) {
        currentLives = lives
        score = SKLabelNode(text:"Score: \(currentScore)")
        score.zPosition = 2
        score.fontSize = 40
        score.fontName = "PipeDream"
        score.position = CGPoint(x: 850, y: 650)
        
        livesNode = SKLabelNode(text: "Lives: \(currentLives)")
        livesNode.zPosition = 2
        livesNode.fontSize = 40
        livesNode.fontName = "PipeDream"
        livesNode.position = CGPoint(x: 200, y: 650)
        
        parentNode.addChild(score)
        parentNode.addChild(livesNode)
    }
    
    func incrementScore() {
        currentScore += 1
        score.text = "Score: \(currentScore)"
    }
    
    func decrementLives() -> Void {
        if(currentLives == 0) {
            return
        }
        
        currentLives -= 1
        livesNode.text = "Lives: \(currentLives)" 
    }
}
