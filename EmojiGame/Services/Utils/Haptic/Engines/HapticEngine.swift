//
//  HapticEngine.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 15.01.2022.
//

import UIKit
import AVFoundation

protocol HapticEngine: AnyObject {
    var id: String { get }
    var player: AVAudioPlayer { get }
    var impactGenerator: UIImpactFeedbackGenerator { get }
    
    func impact(_ callback: @escaping (String) -> Void)
    func set(_ callback: @escaping (_ engineId: String) -> Void)
    func makePlayer(for resource: String, with ext: String) -> AVAudioPlayer
}

extension HapticEngine {
    func impact(_ callback: @escaping (String) -> Void) {
        set(callback)
        
        if player.isPlaying {
            player.stop()
            player.play(atTime: 0)
        } else {
            player.play()
        }
        impactGenerator.impactOccurred()
    }
    
    func makePlayer(for resource: String, with ext: String) -> AVAudioPlayer {
        let url = Bundle.main.url(forResource: resource, withExtension: ext)!
        let player = try! AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
        return player
    }
}
