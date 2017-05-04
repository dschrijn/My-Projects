//
//  AnimationComponent.swift
//  JetPackHero
//
//  Created by David A. Schrijn on 4/28/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import SpriteKit
import GameplayKit

class AnimationComponent: GKComponent {
    let spriteComponent: SpriteComponent!
    var textures: Array<SKTexture> = []
    
    init(entity: GKEntity, textures: Array<SKTexture>) {
        self.textures = textures
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if let player = entity as? PlayerEntity {
            if player.movementAllowed {
                //startAnimation()
            } else {
                stopAnimation("Flap")
            }
        }
    }
    //Main menu character Wobble Function
    func startWobble() {
        let moveUp = SKAction.moveBy(x: 0, y: 10, duration: 0.4)
        moveUp.timingMode = .easeInEaseOut
        let moveDown = moveUp.reversed()
        let sequence = SKAction.sequence([moveUp, moveDown])
        let repeatWobble = SKAction.repeatForever(sequence)
        spriteComponent.node.run(repeatWobble, withKey: "Wobble")
        
        let flapWings = SKAction.animate(with: textures, timePerFrame: 0.07)
        let repeatFlap = SKAction.repeatForever(flapWings)
        spriteComponent.node.run(repeatFlap, withKey: "Wobble-Flap")
    }
    //Main menu character stop Wobble Function
    func stopWobble() {
        stopAnimation("Wobble")
        stopAnimation("Wobble-Flap")    }
    
    //Player invicible animation Function
    func playerInvicible() {
        let enlarge = SKAction.scale(to: 1.5, duration: 0.8)
        
        spriteComponent.node.run(enlarge, withKey: "Invicible")
    }
    func playerReturn() {
        let returnSmall = SKAction.scale(to: 1, duration: 0.8)
        
        spriteComponent.node.run(returnSmall, withKey: "UnInvicible")
    }
    
    //Start Animation Function
    func startAnimation() {
        if(spriteComponent.node.action(forKey: "Flap") == nil) {
            let playerAnimation = SKAction.animate(with: textures, timePerFrame: 0.07)
            let repeatAnimation = SKAction.repeatForever(playerAnimation)
            spriteComponent.node.run(repeatAnimation, withKey: "Flap")
        }
    }
    //Stop Animation Function
    func stopAnimation(_ name: String) {
        spriteComponent.node.removeAction(forKey: name)
    }
}
