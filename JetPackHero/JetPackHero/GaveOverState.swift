//
//  GaveOverState.swift
//  JetPackHero
//
//  Created by David A. Schrijn on 4/26/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState: GKState {
    unowned let scene: GameScene
    
    let hitGroundAction = SKAction.playSoundFileNamed("hitGround.wav", waitForCompletion: false)
    let animationDelay = 0.3
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    //Adding the playing state function
    override func didEnter(from previousState: GKState?) {
        scene.run(hitGroundAction)
        scene.stopSpawning()
        scene.player.movementAllowed = false
        showScoreCard()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }
    
    //Saving Score with UserDefaults.
    func setBestScore(_ bestScore: Int) {
        UserDefaults.standard.set(bestScore, forKey: "BestScore")
        UserDefaults.standard.synchronize()
    }
    //Retrieve Score
    func bestScore() -> Int {
        return UserDefaults.standard.integer(forKey: "BestScore")
    }
    //Function to show scores
    func showScoreCard() {
        if scene.score > self.bestScore() {
            setBestScore(scene.score)
        }
        
        let scoreCard = SKSpriteNode(imageNamed: "Scorecard")
        scoreCard.position = CGPoint(x: scene.size.width * 0.5, y: scene.size.height * 0.5)
        scoreCard.name = "Tutorial"
        scoreCard.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(scoreCard)
        
        let lastScore = SKLabelNode(fontNamed: scene.fontName)
        lastScore.fontColor = SKColor(red: 101.0/255.0, green: 71.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        lastScore.position = CGPoint(x: -scoreCard.size.width * 0.25, y: -scoreCard.size.height * 0.2)
        lastScore.zPosition = Layer.ui.rawValue
        lastScore.text = "\(scene.score / 2)"
        scoreCard.addChild(lastScore)
        
        let bestScore = SKLabelNode(fontNamed: scene.fontName)
        bestScore.fontColor = SKColor(red: 101.0/255.0, green: 71.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        bestScore.position = CGPoint(x: scoreCard.size.width * 0.25, y: -scoreCard.size.height * 0.2)
        bestScore.zPosition = Layer.ui.rawValue
        bestScore.text = "\(self.bestScore() / 2)"
        scoreCard.addChild(bestScore)
        
        let gameOver = SKSpriteNode(imageNamed: "GameOver")
        gameOver.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height / 2 + scoreCard.size.height / 2 + scene.margin + gameOver.size.height / 2)
        gameOver.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(gameOver)
        
        let okButton = SKSpriteNode(imageNamed: "Button")
        okButton.position = CGPoint(x: scene.size.width * 0.25, y: scene.size.height / 2 - scoreCard.size.height / 2 - scene.margin - okButton.size.height / 2)
        okButton.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(okButton)
        
        let okText = SKSpriteNode(imageNamed: "OK")
        okText.position = CGPoint.zero
        okText.zPosition = Layer.ui.rawValue
        okButton.addChild(okText)
        
        let shareButton = SKSpriteNode(imageNamed: "Button")
        shareButton.position = CGPoint(x: scene.size.width * 0.75, y: scene.size.height / 2 - scoreCard.size.height / 2 - scene.margin - shareButton.size.height / 2)
        shareButton.zPosition = Layer.ui.rawValue
        scene.worldNode.addChild(shareButton)
        
        let shareText = SKSpriteNode(imageNamed: "Share")
        shareText.position = CGPoint.zero
        shareText.zPosition = Layer.ui.rawValue
        shareButton.addChild(shareText)
        
        //Animation
        gameOver.setScale(0)
        gameOver.alpha = 0
        let group = SKAction.group([SKAction.fadeIn(withDuration: animationDelay),
            SKAction.scale(to: 1.0, duration: animationDelay)
            ])
        group.timingMode = .easeInEaseOut
        gameOver.run(SKAction.sequence([SKAction.wait(forDuration: animationDelay)
            ]))
        
        
        scoreCard.position = CGPoint(x: scene.size.width * 0.5, y: -scoreCard.size.height / 2)
        let moveTo = SKAction.move(to: CGPoint(x: scene.size.width / 2, y: scene.size.height / 2), duration: animationDelay)
        moveTo.timingMode = .easeInEaseOut
        scoreCard.run(SKAction.sequence([
            SKAction.wait(forDuration: animationDelay * 2),
            moveTo
        ]))
        
        okButton.alpha = 0
        shareButton.alpha = 0
        let fadeIn = SKAction.sequence([
            SKAction.wait(forDuration: animationDelay * 3),
            SKAction.fadeIn(withDuration: animationDelay)
            ])
        okButton.run(fadeIn)
        shareButton.run(fadeIn)
        
        let pops = SKAction.sequence([
            SKAction.wait(forDuration: animationDelay),
            scene.popAction,
            SKAction.wait(forDuration: animationDelay),
            scene.popAction,
            SKAction.wait(forDuration: animationDelay),
            scene.popAction
        ])
        scene.run(pops)
    }
}
