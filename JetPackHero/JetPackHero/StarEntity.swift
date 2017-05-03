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
    
    let texture: SKTexture
    lazy var spriteComponent: SpriteComponent = {
       return SpriteComponent(entity: self, texture: self.texture, size: self.texture.size())
    }()
    
    init(imageName: String) {
        self.texture = SKTexture(imageNamed: imageName)
        
        super.init()
        
        self.addComponent(spriteComponent)
        
        //Adding Physics
        let spriteNode = spriteComponent.node
        spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size)
        spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.star.rawValue
        spriteNode.physicsBody?.collisionBitMask = 0
        spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.player.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
