//
//  Created by Vlad Shchuka on 20.12.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Combine

// MARK: - MainViewModel class
final class MainViewModel {
    // MARK: Output
    var scoreOutut: AnyPublisher<Int, Never> {
        scoreHandler.highestScorePublisher
    }
    
    // MARK: Properties
    private let provider: DependencyProvider
    private var router: MainRouter!
    private let scoreHandler: GameScoreHandler
    private var cancellables: [AnyCancellable] = []

    // MARK: Life Cycle
    init(provider: DependencyProvider) {
        self.provider = provider
        self.scoreHandler = provider.get(GameScoreHandler.self)
    }
    
    // MARK: API
    func inject(router: MainRouter) {
        self.router = router
    }
    
    func playTapped() {
        router.makeGameSceneRoute()
    }
}
