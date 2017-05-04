//
//  MusicPlayerComponent.swift
//  JetPackHero
//
//  Created by David A. Schrijn on 5/1/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class MusicManager {
    
    static let shared = MusicManager()
    
    var audioPlayer = AVAudioPlayer()
    
    
    private init() { } // private singleton init
    
    
    func setup() {
        do {
            audioPlayer =  try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "ninja", ofType: "wav")!))
            audioPlayer.prepareToPlay()
            
        } catch {
            print (error)
        }
    }
    
    
    func play() {
        audioPlayer.play()
    }
    
    func stop() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.prepareToPlay()
    }
}
