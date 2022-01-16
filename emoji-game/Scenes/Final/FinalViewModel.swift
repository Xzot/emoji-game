//
//  Created by Vlad Shchuka on 11.01.2022.
//

import Combine

// MARK: - FinalListener protocol
protocol FinalListener: AnyObject {}

// MARK: - Output
extension FinalViewModel {
    var scorePublisher: AnyPublisher<Int, Never> {
        scoreHandler.scorePublisher.eraseToAnyPublisher()
    }
}

// MARK: - FinalViewModel class
final class FinalViewModel {
    // MARK: Properties
    private let provider: DependencyProvider
    private var router: FinalRouter!
    private let scoreHandler: GameScoreHandler
    private let gameDataProvider: GameDataService
    private let haptic: HapticService
    private weak var listener: FinalListener?
    private let adService: AppAdService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    init(
        provider: DependencyProvider,
        listener: FinalListener?
    ) {
        self.provider = provider
        self.listener = listener
        self.scoreHandler = provider.get(GameScoreHandler.self)
        self.adService = provider.get(AppAdService.self)
        self.haptic = provider.get(HapticService.self)
        self.gameDataProvider = provider.get(GameDataService.self)
    }
    
    // MARK: API
    func inject(router: FinalRouter) {
        self.router = router
    }
    
    func userTapGameOver() {
        haptic.impact(as: .defaultTap)
        gameDataProvider.nextGame()
        router.routeToMain()
        scoreHandler.reset()
    }
    
    func userTapContinue() {
        haptic.impact(as: .defaultTap)
        adService.showInterstitialAd(for: router.presentable!) { [weak self] in
            self?.router.routeBack()
        }
    }
}
