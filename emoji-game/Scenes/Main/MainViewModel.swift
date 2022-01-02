//
//  Created by Vlad Shchuka on 20.12.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Combine

// MARK: - MainViewModel class
final class MainViewModel {
    // MARK: Output
    var scoreOutut: AnyPublisher<Int, Never> {
        scoreState.eraseToAnyPublisher()
    }
    
    // MARK: Properties
    private let provider: DependencyProvider
    private var router: MainRouter!
    private var cancellables: [AnyCancellable] = []
    private let scoreState = CurrentValueSubject<Int, Never>(0)

    // MARK: Life Cycle
    init(provider: DependencyProvider) {
        self.provider = provider
    }
    
    // MARK: API
    func inject(router: MainRouter) {
        self.router = router
    }
    
    func playTapped() {
        router.makeGameSceneRoute()
    }
}
