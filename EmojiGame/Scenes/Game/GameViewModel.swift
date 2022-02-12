//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit
import Combine
import SwiftyUserDefaults

// MARK: - GameListener protocol
protocol GameListener: AnyObject {}

// MARK: - GameViewModelDelegate
protocol GameViewModelDelegate: AnyObject {
    func showDoneAnimation()
    func highlightCorrectAnswers()
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
    
    func handlePause(withSound value: Bool) {
        shouldStartTimeCount = false
        router.routeToPauseScene()
        guard value == true else {
            return
        }
        haptic.impact(as: .defaultTap)
    }
    
    func viewDidAppear() {
        shouldStartTimeCount = true
        timeState.value == 0 ? timeState.send(AppConstants.startGameTime) : nil
        scheduler.isInvalidated ? scheduler.restart() : nil
    }
    
    func fetchNextGameModel() {
        adsCounter += 1
        if adsCounter > 10 && appStateProvider.isHiddenValue(for: .isAdsHidden) == false {
            adsCounter = 0
            shouldStartTimeCount = false
            adService.showInterstitialAd(for: router.presentable!) { [weak self] in
                self?.gameDataProvider.nextGame()
            }
        } else {
            gameDataProvider.nextGame()
        }
    }
}

// MARK: - GameViewModel class
final class GameViewModel {
    // MARK: Properties
    var delegate: GameViewModelDelegate?
    private weak var listener: GameListener?
    private var router: GameRouter!
    private let provider: DependencyProvider
    private let gameDataProvider: GameDataService
    private let scheduler: TimeUpdater
    private let appObserver: AppEventProvider
    private let scoreHandler: GameScoreHandler
    private let appStateProvider: GASProvider
    private let adService: AppAdService
    private let haptic: HapticService
    private var shouldStartTimeCount: Bool = false
    private var gameModelInUse: GameModel?
    private var adsCounter: Int = 0
    
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
        self.gameDataProvider = provider.get(GameDataService.self)
        self.scheduler = provider.get(TimeUpdater.self)
        self.scoreHandler = provider.get(GameScoreHandler.self)
        self.haptic = provider.get(HapticService.self)
        self.appObserver = provider.get(AppEventProvider.self)
        self.adService = provider.get(AppAdService.self)
        self.appStateProvider = provider.get(GASProvider.self)
        
        self.gameDataProvider.delegate = self
        
        self.bind()
    }
}

// MARK: - Private
private extension GameViewModel {
    func bind() {
        gameDataProvider
            .data
            .sink(receiveValue: { [weak self] model in
                self?.handle(model)
            })
            .store(in: &cancellables)
        
        scheduler.completion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard
                    self?.gameModelInUse != nil,
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
        
        appObserver.eventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] appEvent in
                guard appEvent == .didEnterBackground else {
                    return
                }
                self?.handlePause(withSound: false)
            }
            .store(in: &cancellables)
        
        timeState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timeValue in
                guard
                    let self = self,
                    Defaults[\.shouldShowTutorial] == true,
                    timeValue == 6 else {
                        return
                    }
                Defaults[\.shouldShowTutorial] = false
                self.haptic.impact(as: .rightSelection)
                self.delegate?.highlightCorrectAnswers()
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.5,
                    execute: { [weak self] in
                        self?.haptic.impact(as: .rightSelection)
                    }
                )
            }
            .store(in: &cancellables)
    }
    
    func handle(_ gameModel: GameModel?) {
        gameModelInUse != nil ? timeState.send(AppConstants.startGameTime) : nil
        gameModelInUse = gameModel
        
        topLeftState.send(
            GOPItemModel(
                asset: gameModel?.topPanel.left,
                completion: { [weak self] model in
                    self?.handleUserTouch(for: model)
                }
            )
        )
        topCenterState.send(
            GOPItemModel(
                asset: gameModel?.topPanel.center,
                completion: { [weak self] model in
                    self?.handleUserTouch(for: model)
                }
            )
        )
        topRightState.send(
            GOPItemModel(
                asset: gameModel?.topPanel.right,
                completion: { [weak self] model in
                    self?.handleUserTouch(for: model)
                }
            )
        )
        
        bottomLeftState.send(
            GOPItemModel(
                asset: gameModel?.bottomPanel.left,
                completion: { [weak self] model in
                    self?.handleUserTouch(for: model)
                }
            )
        )
        bottomCenterState.send(
            GOPItemModel(
                asset: gameModel?.bottomPanel.center,
                completion: { [weak self] model in
                    self?.handleUserTouch(for: model)
                }
            )
        )
        bottomRightState.send(
            GOPItemModel(
                asset: gameModel?.bottomPanel.right,
                completion: { [weak self] model in
                    self?.handleUserTouch(for: model)
                }
            )
        )
        
        centerImageState.send(gameModel?.result)
        
        guard
            shouldStartTimeCount == false,
            gameModel != nil
        else { return }
        shouldStartTimeCount = true
    }
    
    func handleUserTouch(for model: GOPItemModel) {
        let isAlreadyHandled: Bool = gameDataProvider.latestPickedModels
            .filter {
                $0.unicode == model.unicode
            }
            .count > 0
        guard isAlreadyHandled == false else {
            return
        }
        if model.isCorrect {
            haptic.impact(as: .rightSelection)
            scoreHandler.userDidGuess()
        } else {
            haptic.impact(as: .wrongSelection)
            scoreHandler.userDidNotGuess()
        }
        gameDataProvider.handleModelSelection(model)
    }
    
    func gameOver() {
        haptic.impact(as: .gameOver)
        router.routeToGameOverScene()
        scheduler.invalidate()
        NotificationCenter.default.post(
            name: AppConstants.deselectGameItemNotificationName,
            object: nil
        )
    }
}

// MARK: - GameDataServiceDelegate
extension GameViewModel: GameDataServiceDelegate {
    func gameDataService(
        _ gameDataService: GameDataService,
        handleFullFillFor model: GameModel
    ) {
        Defaults[\.shouldShowTutorial] = false
        shouldStartTimeCount = false
        delegate?.showDoneAnimation()
    }
}

// MARK: - FinalListener
extension GameViewModel: FinalListener {
    func resetGame() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func resetTime() {
        timeState.send(AppConstants.startGameTime)
    }
}
