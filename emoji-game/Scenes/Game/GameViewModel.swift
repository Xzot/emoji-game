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
        router.routeToPauseScene()
    }
}

// MARK: - GameViewModel class
final class GameViewModel {
    // MARK: Properties
    private let provider: DependencyProvider
    private var router: GameRouter!
    private weak var listener: GameListener?
    private let gDataProvider: GameDataProvider
    private let scheduler: TimeUpdater
    private var shouldStartTimeCount: Bool = false
    
    // MARK: - State
    // Status Bar
    private let scoreState = GameScoreState(nil)
    private let timeState = IntState(10)
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
        self.gDataProvider = provider.get(GameDataProvider.self)
        self.scheduler = provider.get(TimeUpdater.self)
        
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
    }
    
    func handle(_ gameModel: GameModel?) {
        topLeftState.send(
            GOPItemModel(asset: gameModel?.topPanel.left) { [weak self] model in
                
            }
        )
        topCenterState.send(
            GOPItemModel(asset: gameModel?.topPanel.center) { [weak self] model in
                
            }
        )
        topRightState.send(
            GOPItemModel(asset: gameModel?.topPanel.right) { [weak self] model in
                
            }
        )
        
        bottomLeftState.send(
            GOPItemModel(asset: gameModel?.bottomPanel.left) { [weak self] model in
                
            }
        )
        bottomCenterState.send(
            GOPItemModel(asset: gameModel?.bottomPanel.center) { [weak self] model in
                
            }
        )
        bottomRightState.send(
            GOPItemModel(asset: gameModel?.bottomPanel.right) { [weak self] model in
                
            }
        )
        
        centerImageState.send(gameModel?.result)
        
        guard
            shouldStartTimeCount == false,
            gameModel != nil
        else { return }
        shouldStartTimeCount = true
    }
    
    func gameOver() {
        router.routeToGameOverScene()
        scheduler.invalidate()
    }
}
