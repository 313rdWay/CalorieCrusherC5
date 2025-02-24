//
//  GameViewController.swift
//  Calorie Crusher (Challenge 5 - MVP)
//
//  Created by Davaughn Williams on 2/24/25.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

enum MusicTrack: String {
    case mainMenu
    case gameplay
    case gameOver
}

class GameViewController: UIViewController {
        
    override func viewDidLoad() {
           super.viewDidLoad()

        // COME BACK TO CONFIGURE TO TRY TO GET THE LOOP MORE IN SYNC
        
           if let view = self.view as! SKView? {
               // Load the SKScene from 'GameScene.sks'
               let scene = HomeScene(size: CGSize(width: 1536, height: 2048))
               // Set the scale mode to scale to fit the window
               scene.scaleMode = .aspectFill
                   
               // Present the scene
               view.presentScene(scene)
               
               view.ignoresSiblingOrder = true
               
               view.showsFPS = false
               view.showsNodeCount = false
           }

       }
    
    final class AudioManager {
        static let shared = AudioManager()
        private var audioPlayer: AVAudioPlayer?
        
        private init() {} // Prevent external initialization
        
        func playMusic(for track: MusicTrack) {
            stopMusic()
            
            let fileName: String
            let fileExtension: String
            
            switch track {
            case .mainMenu:
                fileName = "mainMenuMusic"
                fileExtension = "mp3"
            case .gameplay:
                fileName = "gamePlayMusic"
                fileExtension = "mp3"
            case .gameOver:
                fileName = "gameOverMusic"
                fileExtension = "mp3"
            }
            
            // Load and play the track
            guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
                print("Error: Could not find \(fileName).\(fileExtension)")
                return
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1 // Infinite loop
                audioPlayer?.volume = 0.5
                audioPlayer?.play()
            } catch {
                print("Error playing music: \(error.localizedDescription)")
            }
        }
        
        func stopMusic() {
            audioPlayer?.stop()
            audioPlayer = nil
        }
        
        func pauseMusic() {
            audioPlayer?.pause()
        }
        
        func resumeMusic() {
            audioPlayer?.play()
        }
    }


    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}


