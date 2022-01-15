//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit
import Combine

// MARK: - GameListener protocol
protocol GameListener: AnyObject {}

// MARK: - Output
extension GameViewModel {
    // Status Bar
    var score: GameScorePublisher {
        scoreState.eraseToAnyPublisher()
    }
    var time: IntPublisher {
        timeState.eraseToAnyPublisher()
    }
    
    // Top
    var topLeft: GOPIVMPublisher {
        topLeftState.eraseToAnyPublisher()
    }
    var topCenter: GOPIVMPublisher {
        topCenterState.eraseToAnyPublisher()
    }
    var topRight: GOPIVMPublisher {
        topRightState.eraseToAnyPublisher()
    }
    
    // Center
    var centerImage: ImagePublisher {
        centerImageState.eraseToAnyPublisher()
    }
    
    // Bottom
    var bottomLeft: GOPIVMPublisher {
        bottomLeftState.eraseToAnyPublisher()
    }
    var bottomCenter: GOPIVMPublisher {
        bottomCenterState.eraseToAnyPublisher()
    }
    var bottomRight: GOPIVMPublisher {
        bottomRightState.eraseToAnyPublisher()
    }
}

// MARK: API
extension GameViewModel {
    func inject(router: GameRouter) {
        self.router = router
    }
    
    func handlePause() {
        shouldStartTimeCount = false
        router.routeToPauseScene()
    }
    
    func viewDidAppear() {
        shouldStartTimeCount = true
        timeState.value == 0 ? timeState.send(AppConstants.startGameTime) : nil
        scheduler.isInvalidated ? scheduler.restart() : nil
    }
}

// MARK: - GameViewModel class
final class GameViewModel {
    // MARK: Properties
    private weak var listener: GameListener?
    private var router: GameRouter!
    private let provider: DependencyProvider
    private let gDataProvider: GameDataService
    private let scheduler: TimeUpdater
    private let scoreHandler: GameScoreHandler
    private var shouldStartTimeCount: Bool = false
    private var gameModelInUse: GameModel?
    
    // MARK: - State
    // Status Bar
    private lazy var scoreState = GameScoreState(
        .init(old: nil, new: self.scoreHandler.score)
    )
    private let timeState = IntState(AppConstants.startGameTime)
    // Top
    private let topLeftState = GOPIVMState(nil)
    private let topCenterState = GOPIVMState(nil)
    private let topRightState = GOPIVMState(nil)
    // Center
    private let centerImageState = ImageState(nil)
    // Bottom
    private let bottomLeftState = GOPIVMState(nil)
    private let bottomCenterState = GOPIVMState(nil)
    private let bottomRightState = GOPIVMState(nil)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    init(
        provider: DependencyProvider,
        listener: GameListener?
    ) {
        self.provider = provider
        self.listener = listener
        self.gDataProvider = provider.get(GameDataService.self)
        self.scheduler = provider.get(TimeUpdater.self)
        self.scoreHandler = provider.get(GameScoreHandler.self)
        
        self.bind()
    }
}

// MARK: - Private
private extension GameViewModel {
    func bind() {
        gDataProvider
            .data
            .sink(receiveValue: handle(_:))
            .store(in: &cancellables)
        
        scheduler.completion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard
                    self?.shouldStartTimeCount == true,
                    let oldTime = self?.timeState.value else {
                    return
                }
                let newTime = oldTime - 1
                if newTime >= 0 {
                    self?.timeState.send(newTime)
                } else {
                    self?.gameOver()
                }
            }
            .store(in: &cancellables)
        
        scoreHandler.scorePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newScore in
                guard let self = self else {
                    return
                }
                let model = self.scoreState.value.makeNew(with: newScore)
                self.scoreState.send(model)
            })
            .store(in: &cancellables)
    }
    
    func handle(_ gameModel: GameModel?) {
        let incrementedTime = (timeState.value ?? 0) + 2
        gameModelInUse != nil ? timeState.send(incrementedTime) : nil
        gameModelInUse = gameModel
        
        topLeftState.send(
            GOPItemModel(asset: gameModel?.topPanel.left, completion: handleUserTouch(for:))
        )
        topCenterState.send(
            GOPItemModel(asset: gameModel?.topPanel.center, completion: handleUserTouch(for:))
        )
        topRightState.send(
            GOPItemModel(asset: gameModel?.topPanel.right, completion: handleUserTouch(for:))
        )
        
        bottomLeftState.send(
            GOPItemModel(asset: gameModel?.bottomPanel.left, completion: handleUserTouch(for:))
        )
        bottomCenterState.send(
            GOPItemModel(asset: gameModel?.bottomPanel.center, completion: handleUserTouch(for:))
        )
        bottomRightState.send(
            GOPItemModel(asset: gameModel?.bottomPanel.right, completion: handleUserTouch(for:))
        )
        
        centerImageState.send(gameModel?.result)
        
        guard
            shouldStartTimeCount == false,
            gameModel != nil
        else { return }
        shouldStartTimeCount = true
    }
    
    func handleUserTouch(for model: GOPItemModel) {
        let isAlreadyHandled: Bool = gDataProvider.latestPickedModels
            .filter {
                $0.unicode == model.unicode
            }
            .count > 0
        guard isAlreadyHandled == false else {
            return
        }
        model.isCorrect ? scoreHandler.userDidGuess() : scoreHandler.userDidNotGuess()
        gDataProvider.handleModelSelection(model)
    }
    
    func gameOver() {
        router.routeToGameOverScene()
        scheduler.invalidate()
    }
}
