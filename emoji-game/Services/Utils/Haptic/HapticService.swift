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
final class HapticService: NSObject {
    // MARK: Properties
    private var store = [String : HapticEngine]()
    private let gameStateProvider: GASProvider
    
    // MARK: Life Cycle
    init(gameStateProvider: GASProvider) {
        self.gameStateProvider = gameStateProvider
    }
    
    // MARK: API
    func impact(as style: HapticService.FeedbackStyle) {
        guard gameStateProvider.isHiddenValue(for: .isSoundsHidden) == false else {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                return
            }
            switch style {
            case .defaultTap:
                let defaultEngine = self.makeDefaultEngine()
                self.store[defaultEngine.id] = defaultEngine
                defaultEngine.impact { [weak self] id in
                    self?.store[id] = nil
                }
            case .gameOver:
                let gameOverEngine = self.makeGameOverEngine()
                self.store[gameOverEngine.id] = gameOverEngine
                gameOverEngine.impact { [weak self] id in
                    self?.store[id] = nil
                }
            case .rightSelection:
                let rightSelectionEngine = self.makeRightSelectionEngine()
                self.store[rightSelectionEngine.id] = rightSelectionEngine
                rightSelectionEngine.impact { [weak self] id in
                    self?.store[id] = nil
                }
            case .wrongSelection:
                let wrongSelectionEngine = self.makeWrongSelectionEngine()
                self.store[wrongSelectionEngine.id] = wrongSelectionEngine
                wrongSelectionEngine.impact { [weak self] id in
                    self?.store[id] = nil
                }
            }
        }
    }
}

private extension HapticService {
    func makeDefaultEngine() -> HapticEngine {
        DefaultHapticEngine()
    }
    
    func makeGameOverEngine() -> HapticEngine {
        GameOverHapticEngine()
    }
    
    func makeRightSelectionEngine() -> HapticEngine {
        RightSelectionHapticEngine()
    }
    
    func makeWrongSelectionEngine() -> HapticEngine {
        WrongSelectionHapticEngine()
    }
}
