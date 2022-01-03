//
//  GameDataProvider.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 03.01.2022.
//

import Foundation
import Combine

final class GameDataProvider {
    // MARK: OutPut
    var isReadyToUse: AnyPublisher<Bool, Never> {
        isReadyToUseState.eraseToAnyPublisher()
    }
    
    // MARK: Properties
    private let isReadyToUseState = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: Life Cycle
}
