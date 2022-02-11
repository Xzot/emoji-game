//
//  HypothesisProvider.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 03.01.2022.
//

import Foundation
import SwiftyUserDefaults

// MARK: - Hypothesis
struct Hypothesis {
    let pivotIndex: Int
    let firstItemIndex: Int
    let seccondItemIndex: Int
}

// MARK: - HypothesisProvider class
final class HypothesisProvider {
    // MARK: Properties
    private let emojisProvider: EmojiModelsProvider
    
    // MARK: Life Cycle
    init(emojisProvider: EmojiModelsProvider) {
        self.emojisProvider = emojisProvider
    }
    
    // MARK: API
    func next() -> [Hypothesis]? {
        guard let items = fetchRandomEmojis() else {
            return nil
        }
        return [
            Hypothesis(
                pivotIndex: items.0.idAsIndex,
                firstItemIndex: items.0.idAsIndex,
                seccondItemIndex: items.1.idAsIndex
            ),
            Hypothesis(
                pivotIndex: items.1.idAsIndex,
                firstItemIndex: items.1.idAsIndex,
                seccondItemIndex: items.0.idAsIndex
            )
        ]
    }
}

// MARK: Private
private extension HypothesisProvider {
    func fetchRandomEmojis() -> (EmojiModel, EmojiModel)? {
        let eList = emojisProvider.fetchEmojis()
        if eList.count > 0 {
            // Generate random indexes
            let firstIndex = Int.random(in: (0..<eList.count))
            var seccondIndex = Int.random(in: (0..<eList.count))
            
            // If generated indexes are equal, then it will be regenerate seccond index untill it won't become different
            repeat {
                seccondIndex = Int.random(in: (0..<eList.count))
            } while firstIndex == seccondIndex
            
            return (
                eList[firstIndex],
                eList[seccondIndex]
            )
        } else {
            return nil
        }
    }
}
