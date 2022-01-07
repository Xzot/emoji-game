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
    var data: AnyPublisher<GameModel?, Never> {
        dataSubject.eraseToAnyPublisher()
    }
    
    // MARK: Properties
    private let modelsProvider: GameModelsProvider
    private let readyToPlayQueue = Queue<GameModel>()
    private let dataSubject = CurrentValueSubject<GameModel?, Never>(nil)
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    init(modelsProvider: GameModelsProvider) {
        self.modelsProvider = modelsProvider
        self.modelsProvider.allFetchedModels.forEach { self.readyToPlayQueue.enqueue($0) }
        self.bind()
    }
}

// MARK: - GameDataProvider private extension
private extension GameDataProvider {
    func bind() {
        readyToPlayQueue.listCount
            .sink { [weak self] value in
                if value > 10 {
                    self?.modelsProvider.stopFetching()
                } else {
                    self?.modelsProvider.startFetching()
                }
                
                guard let self = self else {
                    return
                }
                if value > 0 && self.dataSubject.value == nil {
                    self.dataSubject.send(self.readyToPlayQueue.dequeue())
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
