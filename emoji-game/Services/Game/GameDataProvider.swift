//
//  GameDataProvider.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 03.01.2022.
//

import Foundation
import Combine

// MARK: - GameDataProvider class
final class GameDataProvider {
    // MARK: OutPut
    var isReadyToUse: AnyPublisher<Bool, Never> {
        isReadyToUseState.eraseToAnyPublisher()
    }
    
    // MARK: Properties
    private let modelsProvider: GameModelsProvider
    private let readyToPlayQueue = Queue<GameModel>()
    private let isReadyToUseState = CurrentValueSubject<Bool, Never>(false)
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    init(modelsProvider: GameModelsProvider) {
        self.modelsProvider = modelsProvider
        
        self.modelsProvider.allFetchedModels.forEach { self.readyToPlayQueue.enqueue($0) }
    }
}

// MARK: - GameDataProvider private extension
private extension GameDataProvider {
    func bind() {
        readyToPlayQueue.listCount
            .sink { [weak self] value in
                let isReady = value > 0
                if self?.isReadyToUseState.value != isReady {
                    self?.isReadyToUseState.send(value > 0)
                }
                
                if value > 10 {
                    self?.modelsProvider.stopFetching()
                } else {
                    self?.modelsProvider.startFetching()
                }
            }
            .store(in: &cancellable)
        
        modelsProvider.latestFetchedModel
            .sink { [weak self] gameModel in
                self?.readyToPlayQueue.enqueue(gameModel)
            }
            .store(in: &cancellable)
    }
}
