//
//  HomeScreen.swift
//  Calorie Crusher (Challenge 5 - MVP)
//
//  Created by Davaughn Williams on 2/24/25.
//

import SpriteKit
import GameplayKit
import UIKit
var gameScoreLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
    var calorieCounterLabel = SKLabelNode(fontNamed: "SF Pro Rounded")

class HomeScene: SKScene, SKPhysicsContactDelegate {
    
    
    var isTouchEnabled: Bool = false
    var isInfoScreenVisible = false

    
    let player1 = "happyCharacter"
    let player2 = "greenPlayer"
    let player3 = "girlPlayer"
    let player4 = "BmPlayer"
    var players: [String] = []
    var playerNodes: [SKSpriteNode] = []
    var currentPlayyerIndex = 0 // tracks which player is active
    let defaults = UserDefaults.standard
    
    var infoScreen: SKSpriteNode!
    var infoButton: SKSpriteNode!
    var startButton: SKSpriteNode!
    var leftArrow: SKSpriteNode!
    var rightArrow: SKSpriteNode!
    
    var interactiveNodes: [SKSpriteNode] = []
    
    struct PhysicsCategories {
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 // 1 in Binary
        static let Bullet: UInt32 = 0b10 // 2 in Binary
        static let Enemy: UInt32 = 0b100 // 4 in Binary
    }
    
    enum gameState {
        case preGame
        case inGame
        case afterGame
    }
    
    var currentGameState = gameState.preGame
    
    let gameArea: CGRect
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0 / 6.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        GameViewController.AudioManager.shared.playMusic(for: .mainMenu)

        
        self.physicsWorld.contactDelegate = self
        
        // Background
        let background = SKSpriteNode(imageNamed: "dayBackground")
        background.size = self.size
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 0
        addChild(background)
        
        // Terrain
        let terrain = SKSpriteNode(imageNamed: "terrain")
        terrain.size = CGSize(width: 1000, height: 500)
        terrain.position = CGPoint(x: size.width/2, y: size.height/10)
        terrain.zPosition = 1
        addChild(terrain)
        
        // Clouds
        let clouds = SKSpriteNode(imageNamed: "clouds")
        clouds.size = CGSize(width: 1350, height: 500)
        clouds.position = CGPoint(x: size.width / 2, y: size.height / 1.255)
        clouds.zPosition = 2
        addChild(clouds)

        
        // Create Info Screen
        infoScreen = SKSpriteNode(imageNamed: "infoScreen")
        infoScreen.size = CGSize(width: 950, height: 1650)
        infoScreen.position = CGPoint(x: size.width / 2, y: size.height / 2)
        infoScreen.zPosition = 10
        infoScreen.alpha = 0  // Initially hidden
        infoScreen.name = "infoScreen"
        addChild(infoScreen)


        // Create Buttons & Interactive Nodes
        startButton = createInteractiveNode(imageName: "startButton", size: CGSize(width: 600, height: 120), position: CGPoint(x: size.width / 2, y: 1000), name: "startButton")
        infoButton = createInteractiveNode(imageName: "infoButton", size: CGSize(width: 100, height: 100), position: CGPoint(x: size.width * 0.755, y: size.height / 1.10), name: "infoButton")
        leftArrow = createInteractiveNode(imageName: "leftArrow", size: CGSize(width: 300, height: 110), position: CGPoint(x: size.width / 3, y: size.height * 0.22), name: "leftArrow")
        rightArrow = createInteractiveNode(imageName: "rightArrow", size: CGSize(width: 300, height: 110), position: CGPoint(x: size.width / 1.5, y: size.height * 0.22), name: "rightArrow")
        
        // Player
        let player1Nodes = SKSpriteNode(imageNamed: player1)
        player1Nodes.setScale(2.2)
        player1Nodes.position = CGPoint(x: size.width / 2, y: size.height * 0.23)
        player1Nodes.zPosition = 3
        addChild(player1Nodes)
        
        // Player 2
        let player2Nodes = SKSpriteNode(imageNamed: player2)
        player2Nodes.setScale(2.2)
        player2Nodes.position = CGPoint(x: size.width / 2, y: size.height * 0.23)
        player2Nodes.zPosition = 3
        player2Nodes.alpha = 0
        addChild(player2Nodes)
        
        let player3Nodes = SKSpriteNode(imageNamed: player3)
        player3Nodes.setScale(2.2)
        player3Nodes.position = CGPoint(x: size.width / 2, y: size.height * 0.23)
        player3Nodes.zPosition = 3
        player3Nodes.alpha = 0
        addChild(player3Nodes)
        
        let player4Nodes = SKSpriteNode(imageNamed: player4)
        player4Nodes.setScale(2.2)
        player4Nodes.position = CGPoint(x: size.width / 2, y: size.height * 0.23)
        player4Nodes.zPosition = 3
        player4Nodes.alpha = 0
        addChild(player4Nodes)
        
        players = [player1, player2, player3, player4]
        playerNodes = [player1Nodes, player2Nodes, player3Nodes, player4Nodes]
        
    }
    
    // Function to Create Interactive Nodes
    func createInteractiveNode(imageName: String, size: CGSize, position: CGPoint, name: String) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: imageName)
        node.size = size
        node.position = position
        node.zPosition = 3
        node.name = name
        addChild(node)
        interactiveNodes.append(node) // Store it in the array
        return node
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        if let nodeName = touchedNode.name {
            switch nodeName {
            case "startButton":
                print("Start button clicked!")
                startGame()
                
            case "infoButton":
                print("Info button clicked!")
                infoButtonClick()
                showInfo()
                
            case "leftArrow":
                print("Left arrow clicked!")
               switchPlayer(-1)
                
            case "rightArrow":
                print("Right arrow clicked!")
                switchPlayer(1)
                
//            case "closeButton":
//                print("Closing info screen!")
//                closeInfoScreen()
                
            default:
                // If the info screen is open and user clicks outside, close it
                            if isInfoScreenVisible {
                                hideInfoScreen()
                            }
                        }
                    } else {
                        // If the user touches an unnamed node (e.g., background), hide the info screen
                        if isInfoScreenVisible {
                            hideInfoScreen()
                
            }
        }
    }
    
    // Switch player function
    func switchPlayer(_ direction: Int) {
        let currentPlayer = playerNodes[currentPlayyerIndex]
        
        
        currentPlayyerIndex += direction
        
        if currentPlayyerIndex < 0 {
            currentPlayyerIndex = players.count - 1 // Loop baack to last player
        } else if currentPlayyerIndex >= players.count {
            currentPlayyerIndex = 0 // Loop back to first player
        }
        let newPlayer = playerNodes[currentPlayyerIndex]
        let imageName = players[currentPlayyerIndex]
        
        defaults.set(imageName, forKey: "Character")
        print(defaults.object(forKey: "Character") as? String ?? "No Character")
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
           let scaleDown = SKAction.scale(to: 1.8, duration: 0.3) // Slightly shrink
           let fadeIn = SKAction.fadeIn(withDuration: 0.3)
           let scaleUp = SKAction.scale(to: 2.2, duration: 0.3) // Return to normal size

           let disappear = SKAction.group([fadeOut, scaleDown]) // Shrink & fade out
           let appear = SKAction.group([fadeIn, scaleUp]) // Grow & fade in

           currentPlayer.run(disappear) // Hide old player
           newPlayer.run(appear) // Show new player
        
        
        print("Switched to player \(currentPlayyerIndex + 1)")
    }
    
    
    // Actions for Buttons
    func startGame() {
        currentGameState = .inGame
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        startButton.run(SKAction.sequence([fadeOutAction, deleteAction]))
        changeScene()
    }
    
    func changeScene() {
        let sceneToMoveTo = GameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func infoButtonClick() {
        let scaleDown = SKAction.scale(to: 1.8, duration: 0.15) // Slightly shrink
        let scaleUp = SKAction.scale(to: 1, duration: 0.15) // Return to normal size
        infoButton.run(SKAction.sequence([scaleDown, scaleUp]))
    }
    
    func showInfo() {
        if isInfoScreenVisible {
               // If the info screen is already visible, hide it
               hideInfoScreen()
           } else {
               // Show the info screen
               let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
               infoScreen.run(fadeInAction)
               isInfoScreenVisible = true
           }
    }
    
    func hideInfoScreen() {
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        infoScreen.run(fadeOutAction)
        isInfoScreenVisible = false
    }

    
func resetGameState() {
        gameScore = 0
        totalCalories = 0
        gameScoreLabel.text = "\(gameScore)"
        calorieCounterLabel.text = "\(totalCalories)"
    }
}



