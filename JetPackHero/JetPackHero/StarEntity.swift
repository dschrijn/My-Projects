//
//  StarEntity.swift
//  JetPackHero
//
//  Created by David A. Schrijn on 5/1/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import SpriteKit
import GameplayKit

class StarEntity: GKEntity {
    var spriteComponent: SpriteComponent!
    
    init(imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        //Adding Physics
        let spriteNode = spriteComponent.node
        spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
        spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.Star
        spriteNode.physicsBody?.collisionBitMask = 0
        spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.Player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
