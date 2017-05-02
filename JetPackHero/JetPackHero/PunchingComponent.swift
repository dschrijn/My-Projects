//
//  PunchingComponent.swift
//  JetPackHero
//
//  Created by David A. Schrijn on 5/1/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import SpriteKit
import GameplayKit

class PunchingComponent: GKComponent {
    let spriteComponent: SpriteComponent!
    var textures: Array<SKTexture> = []
    var isPunching: Bool = false
    
    init(entity: GKEntity, textures: Array<SKTexture>) {
        self.textures = textures
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyPunch(_ timeInterval: TimeInterval) {
        if !isPunching {
            //Sprite
            let spriteNode = spriteComponent.node as? PlayerEntity
            
            isPunching = true
            print("I'm Punching")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { 
                
                
                self.isPunching = false
                print("Not punching anymore")
            })
        }
        
        
        
    }
    
    
}
