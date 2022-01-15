//
//  DefaultHapticEngine.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 15.01.2022.
//

import UIKit
import AVFoundation

final class DefaultHapticEngine: HapticEngine {
    var player: AVAudioPlayer { _player }
    private lazy var _player: AVAudioPlayer = {
        makePlayer(for: "default_tap", with: "mp3")
    }()
    var impactGenerator: UIImpactFeedbackGenerator { feedbackGenerator }
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
}
