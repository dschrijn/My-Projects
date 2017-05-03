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
    
    let texture: SKTexture
    
    lazy var spriteComponent: SpriteComponent = {
       return SpriteComponent(entity: self, texture: self.texture, size: self.texture.size())
    }()
    
    init(imageName: String) {
        self.texture = SKTexture(imageNamed: imageName)
        super.init()
        
        self.addComponent(self.spriteComponent)
        
        //Adding Physics
        let spriteNode = spriteComponent.node
        let center = CGPoint(x: spriteNode.frame.midX, y: spriteNode.frame.midY)
        spriteNode.physicsBody = SKPhysicsBody(rectangleOf: spriteNode.size, center: center)
        spriteNode.physicsBody!.categoryBitMask = PhysicsCategory.obstacle.rawValue
        spriteNode.physicsBody!.collisionBitMask = 0
        spriteNode.physicsBody!.contactTestBitMask = PhysicsCategory.player.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
