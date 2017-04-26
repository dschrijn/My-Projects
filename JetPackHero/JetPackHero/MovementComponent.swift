//
//  MovementComponent.swift
//  JetPackHero
//
//  Created by David A. Schrijn on 4/25/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import SpriteKit
import GameplayKit

class MovementComponent: GKComponent {
    let spriteComponent: SpriteComponent
    
    //Tapping functionality variables
    var velocity =  CGPoint.zero
    let gravity: CGFloat = -1500
    let impulse: CGFloat = 500
    var playableStart: CGFloat = 0
    let yMax: CGFloat = 1050
    
    init(entity: GKEntity) {
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Func to ascend up when tapped.
    func applyImpulse(_ lastUpdateTime: TimeInterval) {
        velocity = CGPoint(x: 0, y: impulse)
    }
    
    //Func to calculate the movement with time interval.
    func applyMovement(_ seconds: TimeInterval) {
        let spriteNode = spriteComponent.node
        print(spriteNode.position)
        //Apply Gravity
        let gravityStep = CGPoint(x: 0, y: gravity) * CGFloat(seconds)
        velocity += gravityStep
        
        //Apply Velocity & set height constraint
        var velocityStep = velocity * CGFloat(seconds)
        let newPos = velocity + spriteNode.position
        if newPos.y > yMax {
            velocityStep = gravityStep
        }
        spriteNode.position += velocityStep
        
        //Temporary Ground Hit
        if spriteNode.position.y - spriteNode.size.height / 2 < playableStart {
            spriteNode.position = CGPoint(x: spriteNode.position.x, y: playableStart + spriteNode.size.height / 2)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let player = entity as? PlayerEntity {
            applyMovement(seconds)
        }
    }
    
}
