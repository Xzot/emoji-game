//
//  GameScoreHandler.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 09.01.2022.
//

import Combine
import Foundation
import SwiftyUserDefaults

// MARK: - Output
extension GameScoreHandler {
    var score: Int {
        scoreSubject.value
    }
    var scorePublisher: AnyPublisher<Int, Never> {
        scoreSubject.eraseToAnyPublisher()
    }
    var highestScore: Int {
        highestScoreSubject.value
    }
    var highestScorePublisher: AnyPublisher<Int, Never> {
        highestScoreSubject.eraseToAnyPublisher()
    }
}

// MARK: - GameScoreHandler class
final class GameScoreHandler {
    // MARK: Properties
    private let config: GameScoreHandler.Config
    private let scoreSubject = CurrentValueSubject<Int, Never>(0)
    private let highestScoreSubject = CurrentValueSubject<Int, Never>(Defaults[\.scoreRecordValue])
    
    init(config: GameScoreHandler.Config) {
        self.config = config
    }
    
    // MARK: API
    func userDidGuess() {
        scoreSubject.send(scoreSubject.value + config.addedPoints)
        guard scoreSubject.value > highestScoreSubject.value else {
            return
        }
        highestScoreSubject.send(scoreSubject.value)
        Defaults[\.scoreRecordValue] = scoreSubject.value
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
