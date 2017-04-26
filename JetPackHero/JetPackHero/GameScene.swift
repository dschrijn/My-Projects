//
//  GameScene.swift
//  JetPackHero
//
//  Created by David A. Schrijn on 4/23/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Layer: CGFloat {
    case background
    case obstacle
    case foreground
    case player
}

class GameScene: SKScene {
    
    // Mark: Variables
    let worldNode = SKNode()
    var playableStart: CGFloat = 0
    var playableHeight: CGFloat = 0
    let numberOfForegrounds = 2
    var groundSpeed: CGFloat = 150
    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    let bottomObstacleMinFraction: CGFloat = 0.1
    let bottomObstacleMaxFraction: CGFloat = 0.6
    let gapMultiplier: CGFloat = 4.5 //Increase number to decrease difficulty.
    let firstSpawnDelay: TimeInterval = 1.75
    let everySpawnDelay: TimeInterval = 1.5
    let player = PlayerEntity(imageName: "Bird0")
    
    override func didMove(to view: SKView) {
        addChild(worldNode)
        setupBackground()
        startSpawningMultipleObstacles()    
        setupForeground()
        setupPlayer()
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Using to setup timing for ground sprites
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        updateForeground()
        player.update(deltaTime: deltaTime)
    }
    
    // Mark: Functions
    
    //Setup background
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        background.position = CGPoint(x: size.width / 2, y: size.height)
        background.zPosition = Layer.background.rawValue
        
        playableStart = size.height - background.size.height
        playableHeight = background.size.height
        
        worldNode.addChild(background)
    }
    
    //Setup foreground
    func setupForeground() {
        //Looping foreground to make it seem like its moving.
        for i in 0..<numberOfForegrounds {
            
            let foreground = SKSpriteNode(imageNamed: "Ground")
            foreground.anchorPoint = CGPoint(x: 0.0, y: 1.0)
            foreground.position = CGPoint(x: CGFloat(i) * foreground.size.width, y: playableStart)
            foreground.zPosition = Layer.foreground.rawValue
            foreground.name = "foreground"
            
            worldNode.addChild(foreground)
        }
    }
    
    //Function to move foreground.
    func updateForeground() {
        worldNode.enumerateChildNodes(withName: "foreground", using: { node, stop in
            //Setting sprite node and ground speed from update function.
            if let foreground = node as? SKSpriteNode {
                let moveAmount = CGPoint(x: -self.groundSpeed * CGFloat(self.deltaTime), y: 0)

                foreground.position += moveAmount
                
                if foreground.position.x < -foreground.size.width {
                    foreground.position += CGPoint(x: foreground.size.width * CGFloat(self.numberOfForegrounds), y: 0)
                }
            }
        })
    }

    //Adding Player
    func setupPlayer() {
        let playerNode = player.spriteComponent.node
        playerNode.position = CGPoint(x: size.width * 0.2, y: playableHeight * 0.4 + playableStart)
        playerNode.zPosition = Layer.player.rawValue
        
        worldNode.addChild(playerNode)
        player.movementComponent.playableStart = playableStart
        player.update(deltaTime: deltaTime)
        //Call setupPlayer in didMove
    }
    
    //Adding Obstacle
    func createObstacle() -> SKSpriteNode {
        let obstacle = ObstacleEntity(imageName: "Cactus")
        let obstacleNode = obstacle.spriteComponent.node
        obstacleNode.zPosition = Layer.obstacle.rawValue
        
        return obstacle.spriteComponent.node
    }
    
    //Spawning Multiple Obstacles
    func startSpawningMultipleObstacles() {
        let firstDelay = SKAction.wait(forDuration: firstSpawnDelay)
        let spawn = SKAction.run(spawnObstacle)
        let everyDelay = SKAction.wait(forDuration: everySpawnDelay)
        
        let spawnSequence = SKAction.sequence([spawn, everyDelay])
        let foreverSpawn = SKAction.repeatForever(spawnSequence)
        let overallSequence = SKAction.sequence([firstDelay, foreverSpawn])
        
        run(overallSequence)
    }
    
    //Adding obstacle spawning
    func spawnObstacle() {
        //Bottom Obstacle
        let bottomObstacle = createObstacle()
        let startX = size.width + bottomObstacle.size.width / 2
        
        let bottomObstacleMin = (playableStart - bottomObstacle.size.height / 2) + playableHeight * bottomObstacleMinFraction
        let bottomObstacleMax = (playableStart - bottomObstacle.size.height / 2) + playableHeight * bottomObstacleMaxFraction
        
        //Gameplaykit Randomization
        let randomSource = GKARC4RandomSource()
        let randomDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: Int(round(bottomObstacleMin)), highestValue: Int(round(bottomObstacleMax)))
        let randomValue = randomDistribution.nextInt()
        
        bottomObstacle.position = CGPoint(x: startX, y: CGFloat(randomValue))
        worldNode.addChild(bottomObstacle)
        
        //Top Obstacle
        let topObstacle = createObstacle()
        topObstacle.zRotation = CGFloat(180).degreesToRadians()
        topObstacle.position = CGPoint(x: startX, y: bottomObstacle.position.y + bottomObstacle.size.height / 2 + topObstacle.size.height / 2 + player.spriteComponent.node.size.height * gapMultiplier)
        worldNode.addChild(topObstacle)
        
        //Move Obstacles
        let moveX = size.width + topObstacle.size.width
        let moveDuration = moveX / groundSpeed
        
        let sequence = SKAction.sequence([SKAction.moveBy(x: -moveX, y: 0, duration: TimeInterval(moveDuration)),
                                          SKAction.removeFromParent()
                                        ])
        
        topObstacle.run(sequence)
        bottomObstacle.run(sequence)
    }
    
    //Func when touch Begins.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.movementComponent.applyImpulse(lastUpdateTimeInterval)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        player.movementComponent.ascend(lastUpdateTimeInterval)
//    }
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        player.movementComponent.descend(lastUpdateTimeInterval)
//    }
    
}
