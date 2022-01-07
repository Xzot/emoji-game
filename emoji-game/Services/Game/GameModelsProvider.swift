//
//  GameModelsProvider.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 04.01.2022.
//

import UIKit
import Combine
import SwiftyUserDefaults

// MARK: - GameModelsProvider class
final class GameModelsProvider {
    // MARK: Output
    var latestFetchedModel: AnyPublisher<GameModel, Never> {
        latestFetchedModelSubject
            .eraseToAnyPublisher()
    }
    private(set) var allFetchedModels: [GameModel] = []
    
    // MARK: Properties
    private let gModelsFactory: GameModelFactory
    private let hypoProvider: HypothesisProvider
    private let emojiImageLoader: EmojiImageLoader
    private let emojiModelsProvider: EmojiModelsProvider
    
    private var cancellable = Set<AnyCancellable>()
    private let latestFetchedModelSubject = PassthroughSubject<GameModel, Never>()
    
    // MARK: Life Cycle
    init(
        hypoProvider: HypothesisProvider,
        gModelsFactory: GameModelFactory,
        emojiImageLoader: EmojiImageLoader,
        emojiModelsProvider: EmojiModelsProvider
    ) {
        self.hypoProvider = hypoProvider
        self.gModelsFactory = gModelsFactory
        self.emojiImageLoader = emojiImageLoader
        self.emojiModelsProvider = emojiModelsProvider
    }
    
    // MARK: API
    func startFetching() {
        makeNextGameModel()
    }
    
    func stopFetching() {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
    }
}

// MARK: - GameModelsProvider private extension
private extension GameModelsProvider {
    func makeNextGameModel() {
        guard let hypoItems = hypoProvider.next() else {
            return
        }
        let emojis = emojiModelsProvider.fetchEmojis()
        let hypoInUse = hypoItems[Int.random(in: (0..<hypoItems.count))]
        let pivotEmoji = emojis[hypoInUse.pivotIndex]
        let firstEmoji = emojis[hypoInUse.firstItemIndex]
        let seccondEmoji = emojis[hypoInUse.seccondItemIndex]
        
        let patternString = patternFor(
            pivot: pivotEmoji.unicode,
            first: firstEmoji.unicode,
            seccond: seccondEmoji.unicode
        )
        
        if DefaultsChecker.isValueExist(patternString) {
            makeNextGameModel()
        } else {
            emojiImageLoader.loadImagePublisher(patternString)
                .sink { [weak self] image in
                    self?.makeNextGameModel()
                    guard
                        let image = image,
                        let fImage = UIImage(named: firstEmoji.imageName),
                        let sImage = UIImage(named: seccondEmoji.imageName),
                        let gameModel = self?.gModelsFactory.assembly(from: image, and: fImage, sImage)
                    else {
                        return
                    }
                    self?.allFetchedModels.append(gameModel)
                    self?.latestFetchedModelSubject.send(gameModel)
                }
                .store(in: &cancellable)
        }
    }
    
    func patternFor(
        pivot pUnicode: String,
        first fUnicode: String,
        seccond sUnicode: String
    ) -> String {
        "\(pUnicode)%2F\(fUnicode)_\(sUnicode).png"
    }
}

// MARK: - DefaultsChecker fileprivate struct
fileprivate struct DefaultsChecker {
    static func isValueExist(_ value: String) -> Bool {
        var storedItems = Defaults[\.usedHypo]
        if storedItems[value] != nil {
            return true
        } else {
            storedItems[value] = true
            return false
        }
    }
}
