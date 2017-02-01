//
//  GameSprite.swift
//  SheepJump
//
//  Created by Nicholas Lechnowskyj on 2/13/16.
//  Copyright © 2016 Njl. All rights reserved.
//

import SpriteKit

protocol GameSprite {
    
    func spawn(_ parentNode: SKNode, position: CGPoint, size: CGSize?)
}
