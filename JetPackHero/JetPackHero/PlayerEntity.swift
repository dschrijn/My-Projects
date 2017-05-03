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
    
    // MARK: - Properties
    
    let texture: SKTexture
    let numberOfFrames = 3
    var movementAllowed = false

    lazy var spriteComponent: SpriteComponent = {
        return SpriteComponent(entity: self, texture: self.texture, size: self.texture.size())
    }()

    lazy var movementComponent: MovementComponent = {
        return MovementComponent(entity: self)
    }()
    
    lazy var animationComponent: AnimationComponent = self.createAnimationComponent()
    
    lazy var starComponent: StarComponent = {
        let starTexture = SKTexture(imageNamed: "star")
        return StarComponent(entity: self, textures: [starTexture])
    }()
    
    // MARK: - Initialization
    
    init(imageName: String) {
        self.texture = SKTexture(imageNamed: imageName)
        
        super.init()
    
        addComponents()
        movementComponent.applyInitialImpulse()
        addPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func addComponents() {
        addComponent(spriteComponent)
        addComponent(movementComponent)
        addComponent(animationComponent)
        addComponent(starComponent)
    }
    
    func addPhysics() {
        //Add Physics
        let spriteNode = spriteComponent.node
        //let size = spriteNode.size
        //let center = CGPoint(x: spriteNode.frame.midX, y: spriteNode.frame.midY)
        //spriteNode.physicsBody = SKPhysicsBody(rectangleOf: size, center: center)
        spriteNode.physicsBody = SKPhysicsBody(texture: spriteNode.texture!, size: spriteNode.frame.size)
        spriteNode.physicsBody!.categoryBitMask = PhysicsCategory.player.rawValue
        spriteNode.physicsBody!.collisionBitMask = 0
        spriteNode.physicsBody!.contactTestBitMask = PhysicsCategory.obstacle.rawValue | PhysicsCategory.ground.rawValue | PhysicsCategory.star.rawValue
    }
    
    func createAnimationComponent() -> AnimationComponent {
        var textures: [SKTexture] = []
        for i in 0..<numberOfFrames {
            textures.append(SKTexture(imageNamed: "Bird\(i)"))
        }
        //Backwards Animation // Refactor for flapping animation
        for i in stride(from: numberOfFrames, to: 0, by: -1) {
            textures.append(SKTexture(imageNamed: "Bird\(i)"))
        }
        //Add to entity
        return AnimationComponent(entity: self, textures: textures)
    }
    
    
}

