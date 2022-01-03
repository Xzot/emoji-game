//
//  Typealiases.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 03.01.2022.
//

import UIKit
import Combine

// MARK: - Usual callbacks
// MARK: Completions
typealias VoidCompletion = () -> Void


// MARK: - Combine publishers
// MARK: Int
typealias IntPublisher = AnyPublisher<Int?, Never>
typealias IntState = CurrentValueSubject<Int?, Never>

// MARK: UIImage
typealias ImagePublisher = AnyPublisher<UIImage?, Never>
typealias ImageState = CurrentValueSubject<UIImage?, Never>

// MARK: Score
typealias GameScorePublisher = AnyPublisher<GameScore?, Never>
typealias GameScoreState = CurrentValueSubject<GameScore?, Never>
