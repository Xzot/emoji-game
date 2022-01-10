//
//  GameScoreHandler.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 09.01.2022.
//

import Foundation
import Combine

// MARK: - Output
extension GameScoreHandler {
    var scorePublisher: AnyPublisher<Int, Never> {
        scoreSubject.eraseToAnyPublisher()
    }
    var score: Int {
        scoreSubject.value
    }
}

// MARK: - GameScoreHandler class
final class GameScoreHandler {
    // MARK: Properties
    private let config: GameScoreHandler.Config
    private let scoreSubject = CurrentValueSubject<Int, Never>(5)
    
    init(config: GameScoreHandler.Config) {
        self.config = config
    }
    
    // MARK: API
    func userDidGuess() {
        scoreSubject.send(scoreSubject.value + config.addedPoints)
    }
    
    func userDidNotGuess() {
        scoreSubject.send(scoreSubject.value - config.takenAwayPoints)
    }
}

// MARK: - Config
extension GameScoreHandler {
    struct Config {
        let addedPoints: Int
        let takenAwayPoints: Int
    }
}
