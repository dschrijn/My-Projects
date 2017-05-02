//
//  PlayingState.swift
//  JetPackHero
//
//  Created by David A. Schrijn on 4/26/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayingState: GKState {
    unowned let scene: GameScene
    var numberOfFrames = 3
    var punchButton: SKSpriteNode?
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    //Adding the playing state function
    override func didEnter(from previousState: GKState?) {
        scene.startSpawningMultipleObstacles()
        scene.player.movementAllowed = true
        scene.player.animationComponent.startAnimation()
        scene.player.animationComponent.stopWobble()
        setupPunchButton()
        MusicManager.shared.setup()
        MusicManager.shared.play()

    }
    
    override func willExit(to nextState: GKState) {
        removePunchButton()
        MusicManager.shared.stop()
    
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == FallingState.self) || (stateClass == GameOverState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        scene.updateForeground()
        scene.updateScore()
    }
    
    //Creating Punch Button
    func setupPunchButton() {
        
        punchButton = SKSpriteNode(imageNamed: "Button")
        punchButton?.position = CGPoint(x: scene.size.width * 0.5, y: punchButton!.size.height / 2 + scene.margin)
        punchButton?.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(punchButton!)
        
        let punchButtonText = SKSpriteNode(imageNamed: "Play")
        punchButtonText.position = CGPoint.zero
        punchButton?.addChild(punchButtonText)
        
    }
    
    func removePunchButton() {
        punchButton?.removeFromParent()
        punchButton = nil
    }

}
