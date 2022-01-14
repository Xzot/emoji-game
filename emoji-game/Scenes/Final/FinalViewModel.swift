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
    private weak var listener: FinalListener?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    init(
        provider: DependencyProvider,
        listener: FinalListener?
    ) {
        self.provider = provider
        self.listener = listener
        self.scoreHandler = provider.get(GameScoreHandler.self)
    }
    
    // MARK: API
    func inject(router: FinalRouter) {
        self.router = router
    }
    
    func userTapGameOver() {
        router.routeToMain()
        scoreHandler.reset()
    }
}
