//
//  RightSelectionHapticEngine.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 15.01.2022.
//

import UIKit
import AVFoundation

final class RightSelectionHapticEngine: HapticEngine {
    var player: AVAudioPlayer { _player }
    private lazy var _player: AVAudioPlayer = {
        makePlayer(for: "right_selection", with: "mp3")
    }()
    var impactGenerator: UIImpactFeedbackGenerator { feedbackGenerator }
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
}
