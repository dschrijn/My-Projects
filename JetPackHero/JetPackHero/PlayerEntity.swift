//
//  PlayerEntity.swift
//  JetPackHero
//
//  Created by David A. Schrijn on 4/25/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayerEntity: GKEntity {
    var spriteComponent: SpriteComponent!
    var movementComponent: MovementComponent!
    var movementAllowed = false
    var animationComponent: AnimationComponent!
    var punchingComponent: PunchingComponent!
    var numberOfFrames = 3
    
    init (imageName: String) {
        super.init()
        
        let texture = SKTexture(imageNamed: imageName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        movementComponent = MovementComponent(entity: self)
        addComponent(movementComponent)
        
//        //Adding punch textures
//        //Forward punch
//        var punchTextures: Array<SKTexture> = []
//        for i in 0..<numberOfFrames {
//            punchTextures.append(SKTexture(imageNamed: "Punch\(i)"))
//        }
//        //Backwards punch
//        for i in stride(from: numberOfFrames, to: 0, by: -1) {
//            punchTextures.append(SKTexture(imageNamed: "Punch\(i)"))
//        }
//        //Add to Entity
//        punchingComponent = PunchingComponent(entity: self, textures: punchTextures)
//        addComponent(punchingComponent)
        
        //Adding Flapping Textures
        //Forward Animation
        var textures: Array<SKTexture> = []
        for i in 0..<numberOfFrames {
            textures.append(SKTexture(imageNamed: "Bird\(i)"))
        }
        //Backwards Animation // Refactor for flapping animation
        for i in stride(from: numberOfFrames, to: 0, by: -1) {
             textures.append(SKTexture(imageNamed: "Bird\(i)"))
        }
        //Add to entity
        animationComponent = AnimationComponent(entity: self, textures: textures)
        addComponent(animationComponent)
        movementComponent.applyInitialImpulse()
        
        
        
        //Add Physics
        let spriteNode = spriteComponent.node
        spriteNode.physicsBody = SKPhysicsBody(texture: spriteNode.texture!, size: spriteNode.frame.size)
        spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.Player
        spriteNode.physicsBody?.collisionBitMask = 0
        spriteNode.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Ground
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

