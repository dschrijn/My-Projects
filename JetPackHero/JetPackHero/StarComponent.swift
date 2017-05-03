//
//  PunchingComponent.swift
//  JetPackHero
//
//  Created by David A. Schrijn on 5/1/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import SpriteKit
import GameplayKit

class StarComponent: GKComponent {
    let spriteComponent: SpriteComponent!
    var textures: Array<SKTexture> = []
    var isInvulnerable: Bool = false
    
    init(entity: GKEntity, textures: Array<SKTexture>) {
        self.textures = textures
        self.spriteComponent = entity.component(ofType: SpriteComponent.self)!
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyInvulnerable(_ timeInterval: TimeInterval) {
        if !isInvulnerable {
            //Sprite
            let spriteNode = spriteComponent.node as? PlayerEntity
            
            isInvulnerable = true
            print("I'm invicible!!")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
                
                
                self.isInvulnerable = false
                print("Not invicible anymore!!")
            })
        }
        
        
        
    }
    
    
}
