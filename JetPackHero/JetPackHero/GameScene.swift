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
    case star
    case foreground
    case player
    case ui
    case flash
}

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Player: UInt32 = 0b1
    static let Obstacle: UInt32 = 0b10
    static let Star: UInt32 = 0b100
    static let Ground: UInt32 = 0b1000
}

protocol GameSceneDelegate {
    func screenShot() -> UIImage
    func shareString(_ string: String, url: URL, image: UIImage)
    
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    // Mark: Variables
    var gameSceneDelegate: GameSceneDelegate
    let appStoreLink = "https://itunes.apple.com/us/app/" //update when you know they correct URL.
    let worldNode = SKNode()
    var playableStart: CGFloat = 0
    var playableHeight: CGFloat = 0
    let numberOfForegrounds = 2
    var groundSpeed: CGFloat = 150
    var deltaTime: TimeInterval = 0
    var lastUpdateTimeInterval: TimeInterval = 0
    let bottomObstacleMinFraction: CGFloat = 0.1
    let bottomObstacleMaxFraction: CGFloat = 0.6
    let gapMultiplier: CGFloat = 7.5 //Increase number to decrease difficulty.
    let firstSpawnDelay: TimeInterval = 1.75
    let everySpawnDelay: TimeInterval = 1.5
    let player = PlayerEntity(imageName: "Bob0")
    let popAction = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    let gameMusic = SKAction.playSoundFileNamed("epic.wav", waitForCompletion: false)
    var score = 0
    var scoreLabel: SKLabelNode!
    var fontName = "HelveticaNeue-Bold"
    var margin: CGFloat = 20.0
    let coinAction = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
    var initialState: AnyClass
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        MainMenuState(scene: self),
        TutorialState(scene: self),
        PlayingState(scene: self),
        FallingState(scene: self),
        GameOverState(scene: self)
        ])
    
    init(size: CGSize, stateClass: AnyClass, delegate: GameSceneDelegate) {
        gameSceneDelegate = delegate
        initialState = stateClass
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        stateMachine.enter(initialState)
        addChild(worldNode)
        
        //Functions are called in MainMenuState file.
        //setupBackground()
        //setupForeground()
        //setupScoreLabel()
        //setupPlayer()
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Using to setup timing for ground sprites
        if lastUpdateTimeInterval == 0 {
            lastUpdateTimeInterval = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        stateMachine.update(deltaTime: deltaTime)
        player.update(deltaTime: deltaTime)
        
//        if player.punchingComponent.isPunching {
//            groundSpeed = 500
//            
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
//                self.groundSpeed = 150
//            })
//        }
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
        
        //Add Physics
        let lowerLeft = CGPoint(x: 0, y: playableStart)
        let lowerRight = CGPoint(x: size.width, y: playableStart)
        physicsBody = SKPhysicsBody(edgeFrom: lowerLeft, to: lowerRight)
        physicsBody?.categoryBitMask = PhysicsCategory.Ground
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = PhysicsCategory.Player
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
        player.animationComponent.startWobble()
        //Call setupPlayer in didMove
    }
    
    //Function to add score label
    func setupScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: fontName)
        scoreLabel.fontColor = SKColor(red: 101.0/255.0, green: 71.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - margin)
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.zPosition = Layer.ui.rawValue
        scoreLabel.text = "\(score)"
        worldNode.addChild(scoreLabel)
    }
    
    //Updating Score Function
    func updateScore() {
        worldNode.enumerateChildNodes(withName: "obstacle", using: { node, stop in
            if let obstacle = node as? SKSpriteNode {
                if let passed = obstacle.userData?["Passed"] as? NSNumber {
                    if passed.boolValue {
                        return
                    }
                }
                if self.player.spriteComponent.node.position.x > obstacle.position.x + obstacle.size.width / 2 {
                    self.score += 1
                    self.scoreLabel.text = "\(self.score / 2)"
                    obstacle.userData?["Passed"] = NSNumber(value: true as Bool)
                    self.run(self.coinAction)
                }
            }
        })
    }
    
    //Adding Obstacle
    func createObstacle() -> SKSpriteNode {
        let obstacle = ObstacleEntity(imageName: "Cactus")
        let obstacleNode = obstacle.spriteComponent.node
        obstacleNode.zPosition = Layer.obstacle.rawValue
        obstacleNode.name = "obstacle"
        obstacleNode.userData = NSMutableDictionary()
        return obstacle.spriteComponent.node
    }
    
    //Adding Star(Power-Up)
    func createStar() -> SKSpriteNode {
        let star = StarEntity(imageName: "star")
        let starNode = star.spriteComponent.node
        starNode.zPosition = Layer.star.rawValue
        starNode.name = "star"
        return star.spriteComponent.node
    }
    
    //Stopping Spawning Functions
    func stopSpawning() {
        removeAction(forKey: "spawn")
        worldNode.enumerateChildNodes(withName: "obstacle", using: { node, stop in node.removeAllActions()
        })
        worldNode.enumerateChildNodes(withName: "star", using: { node, stop in node.removeAllActions()
        })
    }
    
    //Spawning Multiple Obstacles
    func startSpawningMultipleObstacles() {
        let firstDelay = SKAction.wait(forDuration: firstSpawnDelay)
        let spawn = SKAction.run(spawnObstacle)
        let everyDelay = SKAction.wait(forDuration: everySpawnDelay)
        
        let spawnSequence = SKAction.sequence([spawn, everyDelay])
        let foreverSpawn = SKAction.repeatForever(spawnSequence)
        let overallSequence = SKAction.sequence([firstDelay, foreverSpawn])
        
        
        run(overallSequence, withKey: "spawn")
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
        
        
        //Create Star
        let starNode = createStar()
        starNode.position = CGPoint(x: startX, y: (bottomObstacle.size.height + topObstacle.frame.minY) / 2)
        worldNode.addChild(starNode)
        starNode.isHidden = true
        if score == 1 {
          starNode.isHidden = false
        } else {
            starNode.isHidden = true
        }
        
        
        
        //Move Obstacles
        let moveX = size.width + topObstacle.size.width
        let moveDuration = moveX / groundSpeed
        
        let sequence = SKAction.sequence([SKAction.moveBy(x: -moveX, y: 0, duration: TimeInterval(moveDuration)),
                                          SKAction.removeFromParent()
            ])
        
        topObstacle.run(sequence)
        bottomObstacle.run(sequence)
        starNode.run(sequence)
    }
    //Restart Game Function
    func restartGame(_ stateClass: AnyClass) {
        run(popAction)
        let newScene = GameScene(size: size, stateClass: stateClass, delegate: gameSceneDelegate)
        let transition  = SKTransition.fade(with: SKColor.black, duration: 0.02)
        view?.presentScene(newScene, transition: transition)
    }
    
    //Share to social media Function
    func shareScore() {
        let urlString = appStoreLink
        let url = URL(string: urlString)
        
        let screenShot = gameSceneDelegate.screenShot()
        let initialTextString = "Great! I scored \(score / 2) points in JetPack Hero!"
        gameSceneDelegate.shareString(initialTextString, url: url!, image: screenShot)
    }
    
    //Rate Function
    func rateApp() {
        let urlString = appStoreLink
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    //Learn funtion
    func learn() {
        let urlString = "https://www.raywenderlich.com/flappy-felipe"
        let url = URL(string: urlString)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    //Func for Physics to begin
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        if other.categoryBitMask == PhysicsCategory.Ground {
            // print("hit ground")
            stateMachine.enter(GameOverState.self)
        }
        
//        if other.categoryBitMask == PhysicsCategory.Obstacle && player.punchingComponent.isPunching {
//            
//            return
            //            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            //                self.groundSpeed = 150
            //            })
         else if other.categoryBitMask == PhysicsCategory.Obstacle {
            // print("hit obstacle")
            stateMachine.enter(FallingState.self)
        }
    }
    
    //Func when touch Begins.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            switch stateMachine.currentState {
            case is MainMenuState:
                if touchLocation.y < size.height * 0.15 { // TODO: Refactor to take out Learn button
                    learn()
                } else if touchLocation.x < size.width * 0.6 {
                    restartGame(TutorialState.self)
                } else {
                    rateApp()
                }
            case is TutorialState:
                stateMachine.enter(PlayingState.self)
            case is PlayingState: // TODO: Enter if statement for touching punch button
                if touchLocation.y < size.height * 0.15 {
                    self.player.punchingComponent.applyPunch(lastUpdateTimeInterval)
                } else {
                    player.movementComponent.applyImpulse(lastUpdateTimeInterval)
                }
            case is GameOverState:
                if touchLocation.x < size.width * 0.6 {
                    restartGame(TutorialState.self)
                } else {
                    shareScore()
                }
            default:
                break
            }
        }
        
    }
    
}
