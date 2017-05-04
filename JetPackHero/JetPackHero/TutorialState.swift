//
//  TutorialState.swift
//  JetPackHero
//
//  Created by David A. Schrijn on 4/26/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import SpriteKit
import GameplayKit

class TutorialState: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        setupTutorial()
    }
    
    func setupTutorial() {
        scene.setupBackground()
        scene.setupForeground()
        scene.setupPlayer()
        scene.setupScoreLabel()
        
        //Tutorial
        let tutorial = SKSpriteNode(imageNamed: "BobTutorial")
        tutorial.position = CGPoint(x: scene.size.width * 0.5, y: scene.playableHeight * 0.4 + scene.playableStart)
        tutorial.name = "Tutorial"
        tutorial.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(tutorial)
        
        //Ready
        let ready = SKSpriteNode(imageNamed: "Ready")
        ready.position = CGPoint(x: scene.size.width * 0.5, y: scene.playableHeight * 0.7 + scene.playableStart)
        ready.name = "Tutorial"
        ready.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(ready)
    }
    
    override func willExit(to nextState: GKState) {
        //Remove Tutorial Sprites
        scene.worldNode.enumerateChildNodes(withName: "Tutorial", using: { node, stop in
            node.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()
            ]))
        })
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
}
