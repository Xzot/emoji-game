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
    private let numberOfItemsInside: Int = 2
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
                seccondItemIndex: items.0.idAsIndex
            ),
            Hypothesis(
                pivotIndex: items.0.idAsIndex,
                firstItemIndex: items.0.idAsIndex,
                seccondItemIndex: items.1.idAsIndex
            ),
            Hypothesis(
                pivotIndex: items.1.idAsIndex,
                firstItemIndex: items.1.idAsIndex,
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
            return (
                eList[Int.random(in: (0..<eList.count))],
                eList[Int.random(in: (0..<eList.count))]
            )
        } else {
            return nil
        }
    }
}
