//
//  NoAdsPurchaseCheatService.swift
//  EmojiGame
//
//  Created by Vlad Shchuka on 20.06.2022.
//

import Combine
import Foundation

// MARK: - NoAdsPurchaseCheatServiceDelegate protocol
protocol NoAdsPurchaseCheatServiceDelegate {
    func unlockNoAds()
}

// MARK: - NoAdsPurchaseCheatService final class
final class NoAdsPurchaseCheatService {
    // MARK: - Private properties
    private var counterValue = 0 {
        didSet {
            guard counterValue == 25 else {
                return
            }
            globalAppStateProvider.set(isHidden: true, for: .isAdsHidden)
            hapticEngine.impact(as: .gameOver)
        }
    }
    private let globalAppStateProvider: GASProvider
    private let hapticEngine: HapticService
    
    // MARK: - Life Cycle
    init(
        globalAppStateProvider: GASProvider,
        hapticEngine: HapticService
    ) {
        self.globalAppStateProvider = globalAppStateProvider
        self.hapticEngine = hapticEngine
    }
    
    // MARK: - Public Interface
    func increaseCounter() {
        guard globalAppStateProvider.isHiddenValue(for: .isAdsHidden) == false else {
            return
        }
        counterValue += 1
    }
}
