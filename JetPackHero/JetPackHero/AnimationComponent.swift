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
    var fallingTextures: Array<SKTexture> = []
    
    init(entity: GKEntity, textures: Array<SKTexture>, fallingTextures: Array<SKTexture>) {
        self.textures = textures
        self.fallingTextures = fallingTextures
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
    
    //Player invicible animation Functions
    func playerColorInvicible() {
        let hulk = SKAction.colorize(with: UIColor.green, colorBlendFactor: 1, duration: 0.4)
        spriteComponent.node.run(hulk, withKey: "startColor")
    }
    func playerReturnColor() {
        let originalColor = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.3)
        spriteComponent.node.run(originalColor, withKey: "stopColor")
    }
    func playerBigSizeInvicible() {
        let getLarger = SKAction.scale(by: 4.0, duration: 0.6)
        spriteComponent.node.run(getLarger, withKey: "starPower")
    }
    func playerReturn() {
        let returnSmall = SKAction.scale(to: 1, duration: 0.6)
        spriteComponent.node.run(returnSmall, withKey: "noPower")
    }
    
    //Start Animation Function
    func startAnimation() {
        if(spriteComponent.node.action(forKey: "Flap") == nil) {
            let playerAnimation = SKAction.animate(with: textures, timePerFrame: 0.07)
            let repeatAnimation = SKAction.repeatForever(playerAnimation)
            spriteComponent.node.run(repeatAnimation, withKey: "Flap")
        }
    }
    
    //Falling Animation Function
    func fallingAnimation() {
        if(spriteComponent.node.action(forKey: "Falling") == nil) {
            let playerAnimation = SKAction.animate(with: fallingTextures, timePerFrame: 0.07)
            let repeatAnimation = SKAction.repeatForever(playerAnimation)
            spriteComponent.node.run(repeatAnimation, withKey: "Falling")
        }
    }

    //Stop Animation Function
    func stopAnimation(_ name: String) {
        spriteComponent.node.removeAction(forKey: name)
    }
}
