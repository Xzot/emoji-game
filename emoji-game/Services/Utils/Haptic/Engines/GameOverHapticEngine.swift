//
//  GameOverHapticEngine.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 15.01.2022.
//

import UIKit
import AVFoundation

final class GameOverHapticEngine: HapticEngine {
    var player: AVAudioPlayer { _player }
    private lazy var _player: AVAudioPlayer = {
        makePlayer(for: "game_over", with: "wav")
    }()
    var impactGenerator: UIImpactFeedbackGenerator { feedbackGenerator }
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
}
