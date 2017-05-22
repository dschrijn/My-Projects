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
    let gravity: CGFloat = -1375
    let impulse: CGFloat = 500
    var playableStart: CGFloat = 0
    let yMax: CGFloat = 1000
    let jetPackAction = SKAction.playSoundFileNamed("rocketThruster.wav", waitForCompletion: false)
    var isDead: Bool = false
    
    var velocityModifier: CGFloat = 1000.0
    var angularVelocity: CGFloat = 0.0
    let minDegree: CGFloat = -90
    let maxDegree: CGFloat = 25
    
    var lastTouchTime: TimeInterval = 0
    var lastTouchY: CGFloat = 0.0
    
    init(entity: GKEntity) {
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Double for initial impulse
    func applyInitialImpulse() {
        velocity = CGPoint(x: 0, y: impulse * 1.0)
    }
    //Func to ascend up when tapped.
    func applyImpulse(_ lastUpdateTime: TimeInterval) {
        spriteComponent.node.run(jetPackAction)
        velocity = CGPoint(x: 0, y: impulse)
        
        angularVelocity = velocityModifier.radiansToDegrees()
        lastTouchTime = lastUpdateTime
        lastTouchY = spriteComponent.node.position.y
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
        
        if isDead == true {
            if spriteNode.position.y < lastTouchY {
                angularVelocity = -velocityModifier.radiansToDegrees()
            }
            
            //        Rotation
            let angularStep = angularVelocity * CGFloat(seconds)
            spriteNode.zRotation += angularStep
            spriteNode.zRotation = min(max(spriteNode.zRotation, minDegree.degreesToRadians()), maxDegree.degreesToRadians())
        }
        
        //Ground Collision
        if spriteNode.position.y - spriteNode.size.height / 2 < playableStart {
            spriteNode.position = CGPoint(x: spriteNode.position.x, y: playableStart + spriteNode.size.height / 2)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let player = entity as? PlayerEntity {
            if player.movementAllowed {
                applyMovement(seconds)
            }
        }
        
    }
}
