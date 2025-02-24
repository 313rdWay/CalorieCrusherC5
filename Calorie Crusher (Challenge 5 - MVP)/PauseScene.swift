//
//  PauseScene.swift
//  Calorie Crusher (Challenge 5 - MVP)
//
//  Created by Davaughn Williams on 2/24/25.
//

import Foundation
import SpriteKit

class PauseScene: SKScene {
    let restartLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
    let resumeGameLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
    let goToMainMenu = SKLabelNode(fontNamed: "SF Pro Rounded")
    let muteLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
    let unmuteLabel = SKLabelNode(fontNamed: "SF Pro Rounded")


    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "dayBackground")
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
        let pausedLabel = SKLabelNode(fontNamed: "SF Pro Rounded")
        pausedLabel.text = "PAUSED"
        pausedLabel.fontSize = 175
        pausedLabel.fontColor = SKColor.white
        pausedLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        pausedLabel.zPosition =  1
        self.addChild(pausedLabel)
        
        // Restart Button Label
        restartLabel.text = "RESTART"
        restartLabel.fontSize = 100
        restartLabel.fontColor = .white
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)

        self.addChild(restartLabel)
       
        resumeGameLabel.text = "RESUME GAME"
        resumeGameLabel.fontSize = 100
                
        resumeGameLabel.fontColor = .white
        resumeGameLabel.zPosition = 1
        resumeGameLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)

        self.addChild(resumeGameLabel)
        
        // Main Menu Button Label
        goToMainMenu.text = "MAIN MENU"
        goToMainMenu.fontSize = 100
        goToMainMenu.fontColor = .white
//        goToMainMenu.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        goToMainMenu.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        goToMainMenu.zPosition = 1
        self.addChild(goToMainMenu)
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pointOfTouch = touch.location(in: self)

            if restartLabel.contains(pointOfTouch) {
                // Reset game state by creating a NEW GameScene
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                sceneToMoveTo.resetGameState() // Add this method in GameScene
                self.view?.presentScene(sceneToMoveTo, transition: SKTransition.fade(withDuration: 0.5))
            }

            if resumeGameLabel.contains(pointOfTouch) {
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
                // Unpause the existing GameScene instead of creating a new one
                self.view?.isPaused = false // Resume gameplay
                self.removeFromParent() // Remove the pause overlay
            }

            if goToMainMenu.contains(pointOfTouch) {
                let sceneToMoveTo = HomeScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                sceneToMoveTo.resetGameState() // Add this method in GameScene
                self.view?.presentScene(sceneToMoveTo, transition: SKTransition.fade(withDuration: 0.5))
            }
        }
    }
}
    
//}

