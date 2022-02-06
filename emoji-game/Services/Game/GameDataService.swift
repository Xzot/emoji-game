//
//  GameDataProvider.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 03.01.2022.
//

import Foundation
import Combine

// MARK: - Delegate
protocol GameDataServiceDelegate: AnyObject {
    func gameDataService(
        _ gameDataService: GameDataService,
        handleFullFillFor model: GameModel
    )
}

// MARK: - GameDataService class
final class GameDataService {
    // MARK: OutPut
    var data: AnyPublisher<GameModel?, Never> {
        dataSubject.eraseToAnyPublisher()
    }
    var delegate: GameDataServiceDelegate?
    
    // MARK: Properties
    private let modelsProvider: GameModelsProvider
    private let readyToPlayQueue = Queue<GameModel>()
    private let dataSubject = CurrentValueSubject<GameModel?, Never>(nil)
    private var cancellable = Set<AnyCancellable>()
    private(set) var latestPickedModels = [GOPItemModel]()
    
    // MARK: Life Cycle
    init(modelsProvider: GameModelsProvider) {
        self.modelsProvider = modelsProvider
        self.modelsProvider.allFetchedModels.forEach { self.readyToPlayQueue.enqueue($0) }
        self.bind()
    }
    
    // MARK: API
    func nextGame() {
        guard latestPickedModels.count > 0 else {
            return
        }
        dataSubject.value?.markAsUsed()
        latestPickedModels.removeAll()
        dataSubject.send(readyToPlayQueue.dequeue())
    }
    
    func handleModelSelection(_ model: GOPItemModel) {
        guard
            model.isCorrect == true,
            let gameData = dataSubject.value
        else { return }
        
        latestPickedModels.append(model)
        
        guard
            gameData.isFullyGuessed(latestPickedModels) == true
        else { return }
        
        delegate?.gameDataService(
            self,
            handleFullFillFor: gameData
        )
    }
}

// MARK: - GameDataService private extension
private extension GameDataService {
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
