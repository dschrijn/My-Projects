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
        //scene.player.animationComponent.startAnimation()
        scene.player.animationComponent.stopWobble()
        MusicManager.shared.setup()
        MusicManager.shared.play()

    }
    
    override func willExit(to nextState: GKState) {

        MusicManager.shared.stop()
    
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == FallingState.self) || (stateClass == GameOverState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        scene.updateForeground()
        scene.updateScore()
    }

}
