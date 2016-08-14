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
    init(parentNode:SKNode, lives: Int){
        currentLives = lives
        score = SKLabelNode(text:"Score: " + String(currentScore))
        score.zPosition = 2
        score.fontSize = 40
       // score.fontColor = UIColor.blackColor()
        score.fontName = "PipeDream"
        score.position = CGPointMake(850, 650)
        
        livesNode = SKLabelNode(text: "Lives: " + String(currentLives))
        livesNode.zPosition = 2
        livesNode.fontSize = 40
        livesNode.fontName = "PipeDream"
        livesNode.position = CGPointMake(200, 650)
        
        parentNode.addChild(score)
        parentNode.addChild(livesNode)
    }
    
    func incrementScore() {
        score.text = "Score: " + String(++currentScore)
    }
    
    func decrementLives() {
        livesNode.text = "Lives: " + String(--currentLives)
    }
}
