//
//  HapticService.swift
//  Pics (iOS)
//
//  Created by Сергей Сивагин on 30.08.2021.
//

import UIKit
import AVFoundation

// MARK: - FeedbackStyle enum
extension HapticService {
    enum FeedbackStyle {
        case defaultTap
        case gameOver
        case rightSelection
        case wrongSelection
    }
}

// MARK: - HapticService class
final class HapticService {
    // MARK: Properties
    private lazy var defaultEngine = DefaultHapticEngine()
    private lazy var gameOverEngine = GameOverHapticEngine()
    private lazy var rightSelectionEngine = RightSelectionHapticEngine()
    private lazy var wrongSelectionEngine = WrongSelectionHapticEngine()
    
    
    // MARK: API
    func impact(as style: HapticService.FeedbackStyle) {
        switch style {
        case .defaultTap:
            defaultEngine.impact()
        case .gameOver:
            gameOverEngine.impact()
        case .rightSelection:
            rightSelectionEngine.impact()
        case .wrongSelection:
            wrongSelectionEngine.impact()
        }
    }
}
