//
//  MainMenuScene.swift
//  SheepJump
//
//  Created by Nicholas Lechnowskyj on 2/10/16.
//  Copyright © 2016 Njl. All rights reserved.
//

import SpriteKit

class MainMenuScene : SKScene {
    var startButton : SKNode!
    override init(size: CGSize) {
        super.init(size: size)
        
        startButton = self.childNodeWithName("StartGame_Container")!
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        startButton = self.childNodeWithName("StartGame_Container")!
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.locationInNode(self)
        if(startButton.containsPoint(touchLocation!)){
            let c = self.view?.window?.rootViewController as! MainMenuViewController
          
            c.transitionToOtherViewController()
            //let transition = SKTransition.doorsOpenHorizontalWithDuration(1.0)
            //let nextScene = GameScene(fileNamed: "GameScene")
           // nextScene?.scaleMode = .Fill
            
            //scene?.view?.presentScene(nextScene!, transition: transition)
        }
    }
}