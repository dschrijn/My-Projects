//
//  ObstacleEntity.swift
//  JetPackHero
//
//  Created by David A. Schrijn on 4/25/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import SpriteKit
import GameplayKit

class ObstacleEntity: GKEntity {
    var spriteComponent: SpriteComponent!
    
    init(imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        //Adding Physics
        let spriteNode = spriteComponent.node
        let center = CGPoint(x: spriteNode.frame.midX, y: spriteNode.frame.midY)
        spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size, center: center)
        spriteNode.physicsBody!.categoryBitMask = PhysicsCategory.Obstacle
        spriteNode.physicsBody!.collisionBitMask = 0
        spriteNode.physicsBody!.contactTestBitMask = PhysicsCategory.Player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
