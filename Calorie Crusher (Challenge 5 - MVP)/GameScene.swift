//
//  GameScene.swift
//  Calorie Crusher (Challenge 5 - MVP)
//
//  Created by Davaughn Williams on 2/24/25.
//

import SpriteKit
import GameplayKit

var gameScore = 0
var totalCalories = 0

class GameScene: SKScene, SKPhysicsContactDelegate {

    var player = SKSpriteNode(imageNamed: "happyCharacter")
    let defaults = UserDefaults.standard
    let gameScoreLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
    let calorieCounterLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
    var lastUpdateTime: TimeInterval = 0
    var levelNumber = 0
    let nightScene = SKNode()
    let dayScene = SKNode()
    let pauseButton = SKSpriteNode(imageNamed: "pauseButton")



    struct PhysicsCategories {
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 // 1 in Binary
        static let Food: UInt32 = 0b10 // 2 in Binary
    }
    
    enum gameState {
        case preGame // When the game state is before the start of the game
        case inGame // When the game state is during the game
        case afterGame // When the game state is after the game
    }
    
    var currentGameState = gameState.inGame
    
    struct Food {
        let name: String
        let imageName: String
        let calories: Int
        let isHealthy: Bool
        let isPowerUp: Bool
        let weight: Int
    }
    
    // Randomized Function for food to spawn onto our scene
    func random() -> CGFloat {
        return CGFloat.random(in: 0...1)
    }
    
    // Randomized the area in which our food flies into the Scene
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }

// GameArea
    let gameArea: CGRect
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/7.2
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to: SKView) {
        
        GameViewController.AudioManager.shared.playMusic(for: .gameplay)
        
        self.physicsWorld.contactDelegate = self
        
        // Daytime Background
        addChild(dayScene)
        
        let background = SKSpriteNode(imageNamed: "dayBackground")
        background.size = self.size
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 0

        
                
        let clouds = SKSpriteNode(imageNamed: "clouds")
        clouds.size = CGSize(width: 1350, height: 500)
        clouds.position = CGPoint(x: size.width / 2, y: size.height / 1.255)
        clouds.zPosition = 2
        
        dayScene.addChild(background)
        dayScene.addChild(clouds)

        
        
        // Terrain (For Both Backgrounds)
        let terrain = SKSpriteNode(imageNamed: "terrain")
        terrain.size = CGSize(width: 1000, height: 500)
        terrain.position = CGPoint(x: size.width/2, y: size.height/10)
        terrain.zPosition = 3
        addChild(terrain)
        
        pauseButton.size = CGSize(width: 35, height: 50)
        pauseButton.position = CGPoint(x: size.width/2, y: size.height - 160)
        pauseButton.zPosition = 3
        addChild(pauseButton)

        
        // Player
        let playerImage = defaults.object(forKey: "Character") as! String
//        let playerImage = defaults.object(forKey: "Character") as? String ?? "defaultCharacter"
        player = SKSpriteNode(imageNamed: playerImage)
        
        player.setScale(2)
        player.position = CGPoint(x: self.size.width/2, y: player.size.height * 1.78)
        player.zPosition = 5
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Food
        self.addChild(player)
        
        
        
        // ScoreBoard
        let scoreContainer = SKNode()
        self.addChild(scoreContainer)
        
        let scoreLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
        scoreLabel.text = "SCORE"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = .white
//        scoreLabel.position = CGPoint(x: 0, y: -20)
        scoreLabel.position = CGPoint(x: 0, y: -50)
        scoreLabel.zPosition = 99
        
        
        gameScoreLabel.text = "\(gameScore)"
        gameScoreLabel.fontSize = 70
        gameScoreLabel.fontColor = SKColor.white
//        gameScoreLabel.position = CGPoint(x: 0, y: -90)
        gameScoreLabel.position = CGPoint(x: 0, y: -110)
        gameScoreLabel.zPosition = 99

        let scoreLabelBackground = SKSpriteNode(imageNamed: "rectangle1")
        scoreLabelBackground.size = CGSize(width: 300, height: 150)
        scoreLabelBackground.position = CGPoint(x: scoreLabel.position.x, y: (scoreLabel.position.y + gameScoreLabel.position.y) / 2) // Centered between labels
        scoreLabelBackground.zPosition = 98
        
        scoreContainer.addChild(scoreLabel)
        scoreContainer.addChild(gameScoreLabel)
        scoreContainer.addChild(scoreLabelBackground)
        
        scoreContainer.position = CGPoint(x: self.size.width * 0.28, y: self.size.height * 0.95)
        scoreContainer.zPosition = 100
        
        
        
        
        // Calorie Tracker
        let caloriesContainer = SKNode()
        self.addChild(caloriesContainer)
        
        let caloriesLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
        caloriesLabel.text = "CALORIES"
        caloriesLabel.fontSize = 50
        caloriesLabel.fontColor = .white
//        caloriesLabel.position = CGPoint(x: 0, y: -20)
        caloriesLabel.position = CGPoint(x: 0, y: -50)

        caloriesLabel.zPosition = 99

        
        calorieCounterLabel.text = "\(totalCalories)"
        calorieCounterLabel.fontSize = 70
        calorieCounterLabel.fontColor = .white
        calorieCounterLabel.position = CGPoint(x: 0, y: -110)
        calorieCounterLabel.zPosition = 99

        
        let calorieLabelBackground = SKSpriteNode(imageNamed: "rectangle2")
        calorieLabelBackground.size = CGSize(width: 300, height: 150)
        calorieLabelBackground.position = CGPoint(x: scoreLabel.position.x, y: (scoreLabel.position.y + gameScoreLabel.position.y) / 2) // Centered between labels
        calorieLabelBackground.zPosition = 98
        
        caloriesContainer.addChild(caloriesLabel)
        caloriesContainer.addChild(calorieCounterLabel)
        caloriesContainer.addChild(calorieLabelBackground)
        
        caloriesContainer.position = CGPoint(x: self.size.width * 0.72, y: self.size.height * 0.95)
        scoreContainer.zPosition = 100
        
        
        
        startNewLevel()
    }

    
    // Contact
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Food {
            if let foodNode = body2.node as? SKSpriteNode {
                if let food = allFoods.first(where: { $0.imageName == foodNode.name }) {
                    if food.name == "Golden Apple" {
                        totalCalories /= 2
                        calorieCounterLabel.text = "\(totalCalories / 2)"
                    } else {
                        totalCalories += food.calories
                    }
                    calorieCounterLabel.text = "\(totalCalories)"
                    }
                if totalCalories >= 30_000 {
                    runGameOver()
//                    scene?.view?.isPaused = true
//                    showLifeLine()
//                    hideDayScene()
//                    showNightScene()
                }
                }
                body2.node?.removeFromParent() // Remove the food from scene
            }
        }
    

    // Food Array
    let allFoods: [Food] = [
        Food(name: "Donut", imageName: "donut", calories: 350, isHealthy: false, isPowerUp: false, weight: 10),
        Food(name: "Pizza", imageName: "pizza", calories: 285, isHealthy: false, isPowerUp: false, weight: 10),
        Food(name: "Burger", imageName: "burger", calories: 354, isHealthy: false, isPowerUp: false, weight: 10),
        Food(name: "Bacon", imageName: "bacon", calories: 43, isHealthy: false, isPowerUp: false, weight: 10),
        Food(name: "Cookie", imageName: "cookie", calories: 78, isHealthy: false, isPowerUp: false, weight: 10),
        
        Food(name: "Broccoli", imageName: "broccoli", calories: 50, isHealthy: true, isPowerUp: false, weight: 10),
        Food(name: "Strawberry", imageName: "strawberry", calories: 5, isHealthy: true, isPowerUp: false, weight: 10),
        Food(name: "Orange", imageName: "orange", calories: 45, isHealthy: true, isPowerUp: false, weight: 10),
        Food(name: "Avocado", imageName: "avocado", calories: 240, isHealthy: true, isPowerUp: false, weight: 10),
        Food(name: "Carrot", imageName: "carrot", calories: 25, isHealthy: true, isPowerUp: false, weight: 10),
        
        Food(name: "Golden Apple", imageName: "goldenApple", calories: 0, isHealthy: true, isPowerUp: true, weight: 1),
        Food(name: "Hot Pepper", imageName: "hotPepper", calories: 30, isHealthy: true, isPowerUp: false, weight: 10)
    ]

    // Updates the player's score by 100 every second they survive the game
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        
        
        let deltaTime = currentTime - lastUpdateTime
        if currentGameState == .inGame {
            if deltaTime >= 1.0 {
                gameScore += 100
                gameScoreLabel.text = "\(gameScore)"
                lastUpdateTime = currentTime
            }
            levelSystem()
        }
    }
    
    

    // Deals with how often the game speeds up
    func levelSystem() {
        let nextThreshold = (levelNumber + 1) * 1000
        if gameScore >= nextThreshold {
            startNewLevel()
        }
    }

    
    // Deals with the speed of our game
    func startNewLevel() {
        levelNumber += 1
        print("Starting level \(levelNumber)")
        
        // Remove existing spawning action
        self.removeAction(forKey: "spawningFoods")
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 0.5
        case 2: levelDuration = 0.3
        case 3: levelDuration = 0.2
        default:
            levelDuration = 0.2
            print("Using default duration for higher levels")
        }
        
        // Create new spawning action
        let spawnAction = SKAction.run { self.spawnFood() }
        let wait = SKAction.wait(forDuration: levelDuration)
        let sequence = SKAction.sequence([wait, spawnAction])
        let repeatForever = SKAction.repeatForever(sequence)
        
        self.run(repeatForever, withKey: "spawningFoods")
    }
    
    // Run our game over and stops gameplay
    func runGameOver() {
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "randomFood.imageName") { food, stop in
            food.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    // Changes our scene again
    func changeScene() {
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    // Make sure our foods have different rarities
    func getRandomFood() -> Food {
        let totalWeight = allFoods.reduce(0) { $0 + $1.weight
        }
        let randomValue = Int.random(in: 0..<totalWeight)
        
        var cumulativeWeight = 0
        for food in allFoods {
            cumulativeWeight += food.weight
            if randomValue < cumulativeWeight {
                return food
            }
        }
        return allFoods[0]
    }
    
    
    // Soawns in Food from the clouds
    func spawnFood() {
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)

        let startPoint = CGPoint(x: randomXStart, y: size.height / 1.255)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)


        let randomFood = getRandomFood()

        let food = SKSpriteNode(imageNamed: randomFood.imageName)
        food.name = randomFood.imageName
        food.setScale(2)
        food.position = startPoint
        food.zPosition = 1
        food.physicsBody = SKPhysicsBody(rectangleOf: food.size)
        food.physicsBody!.affectedByGravity = false
        food.physicsBody!.categoryBitMask = PhysicsCategories.Food
        food.physicsBody!.collisionBitMask = PhysicsCategories.None
        food.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(food)

        let moveFood = SKAction.move(to: endPoint, duration: 5)
        let deleteFood = SKAction.removeFromParent()
        let foodSequence = SKAction.sequence([moveFood, deleteFood])

        if currentGameState == gameState.inGame {
            food.run(foodSequence)
        }
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let pointOfTouch2 = touch.location(in: self)

        print("Touch detected at: \(location)")
        
        if pauseButton.contains(pointOfTouch2) {
            
            let sceneToMoveTo = PauseScene(size: self.size)
            sceneToMoveTo.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            
            self.view?.isPaused = false // Resume gameplay

        }
    }
    
    
    // Tranisitions us to the Main Menu
    func changeSceneToHomeScene() {
        let sceneToMoveTo = HomeScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    // Reset Game State
    func resetGameState() {
            gameScore = 0
            totalCalories = 0
            gameScoreLabel.text = "\(gameScore)"
            calorieCounterLabel.text = "\(totalCalories)"
        }

    

    // Touches that are slide across our screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
        
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame {
                player.position.x += amountDragged
            }
            if player.position.x > gameArea.maxX - player.size.width/2 {
                player.position.x = gameArea.maxX - player.size.width/2
            }
            if player.position.x < gameArea.minX + player.size.width/2 {
                player.position.x = gameArea.minX + player.size.width/2
            }
        }
    }
}
