//
//  GameOverScene.swift
//  Calorie Crusher (Challenge 5 - MVP)
//
//  Created by Davaughn Williams on 2/24/25.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    let restartLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
    let returnHomeLabel = SKLabelNode(fontNamed: "SF Pro Rounded")

    
    override func didMove(to view: SKView) {
        
        GameViewController.AudioManager.shared.playMusic(for: .gameOver)

        
        let background = SKSpriteNode(imageNamed: "nightBackground")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        let terrain = SKSpriteNode(imageNamed: "terrain")
        terrain.size = CGSize(width: 1000, height: 500)
        terrain.position = CGPoint(x: size.width/2, y: size.height/10)
        terrain.zPosition = 3
        self.addChild(terrain)
        
        // Label Reading "Game Over"
        let gameOverLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 175
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition =  1
        self.addChild(gameOverLabel)
        
        // Label Reading "Player's Final Score"
        let scoreLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        // High Score Logic to Save and Update the High Score everytime one is achieved
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        // Label Reading Player's "High Score"
        let highScoreLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = .white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)

        let maxLabelWidth = size.width * 0.8
        highScoreLabel.preferredMaxLayoutWidth = maxLabelWidth

        
        self.addChild(highScoreLabel)
        
        // Restart Button Label
        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = .white
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        self.addChild(restartLabel)
        
//        let returnHomeLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
        returnHomeLabel.text = "Return Home"
        returnHomeLabel.fontSize = 90
        returnHomeLabel.fontColor = .white
        returnHomeLabel.zPosition = 1
        returnHomeLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.2)
        self.addChild(returnHomeLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch) {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                sceneToMoveTo.resetGameState() // Add this method in GameScene
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            if returnHomeLabel.contains(pointOfTouch) {
                let sceneToMoveTo = HomeScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                sceneToMoveTo.resetGameState() // Add this method in GameScene
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}

