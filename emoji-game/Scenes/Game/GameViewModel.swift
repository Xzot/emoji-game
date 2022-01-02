//
//  Created by Vlad Shchuka on 02.01.2022.
//

import Combine

// MARK: - GameListener protocol
protocol GameListener: AnyObject {}

// MARK: - GameViewModel class
final class GameViewModel {
    // MARK: Properties
    private let provider: DependencyProvider
    private var router: GameRouter!
    private weak var listener: GameListener?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    init(
        provider: DependencyProvider,
        listener: GameListener?
    ) {
        self.provider = provider
        self.listener = listener
    }
    
    // MARK: API
    func inject(router: GameRouter) {
        self.router = router
    }
}
