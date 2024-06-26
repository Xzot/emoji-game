//
//  WrongSelectionHapticEngine.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 15.01.2022.
//

import UIKit
import AVFoundation

final class WrongSelectionHapticEngine: NSObject, HapticEngine {
    var id: String = UUID().uuidString
    func set(_ callback: @escaping (String) -> Void) {
        closure = callback
    }
    private var closure: ((String) -> Void)!
    
    var player: AVAudioPlayer { _player }
    private lazy var _player: AVAudioPlayer = {
        let player = makePlayer(for: "wrong_selection", with: "mp3")
        player.delegate = self
        return player
    }()
    var impactGenerator: UIImpactFeedbackGenerator { feedbackGenerator }
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
}

extension WrongSelectionHapticEngine: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        closure(id)
    }
}
