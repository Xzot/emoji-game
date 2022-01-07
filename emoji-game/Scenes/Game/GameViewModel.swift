//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit
import Combine

// MARK: - GameListener protocol
protocol GameListener: AnyObject {}

// MARK: - PanelItem struct
extension GameViewModel {
    struct PanelItem {
        let image: UIImage
        let isCorrect: Bool
        let state: PState
        
    }
}

// MARK: - PanelItem's state
extension GameViewModel.PanelItem {
    enum PState {
        case normal
        case correct
        case wrong
    }
}

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
    var topLeftImage: ImagePublisher {
        topLeftImageState.eraseToAnyPublisher()
    }
    var topCenterImage: ImagePublisher {
        topCenterImageState.eraseToAnyPublisher()
    }
    var topRightImage: ImagePublisher {
        topRightImageState.eraseToAnyPublisher()
    }
    
    // Center
    var centerImage: ImagePublisher {
        centerImageState.eraseToAnyPublisher()
    }
    
    // Bottom
    var bottomLeftImage: ImagePublisher {
        bottomLeftImageState.eraseToAnyPublisher()
    }
    var bottomCenterImage: ImagePublisher {
        bottomCenterImageState.eraseToAnyPublisher()
    }
    var bottomRightImage: ImagePublisher {
        bottomRightImageState.eraseToAnyPublisher()
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
    private let topLeftImageState = ImageState(nil)
    private let topCenterImageState = ImageState(nil)
    private let topRightImageState = ImageState(nil)
    // Center
    private let centerImageState = ImageState(nil)
    // Bottom
    private let bottomLeftImageState = ImageState(nil)
    private let bottomCenterImageState = ImageState(nil)
    private let bottomRightImageState = ImageState(nil)
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
                if newTime > 0 {
                    self?.timeState.send(newTime)
                } else {
                    self?.gameOver()
                }
            }
            .store(in: &cancellables)
    }
    
    func handle(_ gameModel: GameModel?) {
        topLeftImageState.send(gameModel?.topPanel.left.image)
        topCenterImageState.send(gameModel?.topPanel.center.image)
        topRightImageState.send(gameModel?.topPanel.right.image)
        
        bottomLeftImageState.send(gameModel?.bottomPanel.left.image)
        bottomCenterImageState.send(gameModel?.bottomPanel.center.image)
        bottomRightImageState.send(gameModel?.bottomPanel.right.image)
        
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
