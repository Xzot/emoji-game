//
//  Created by Vlad Shchuka on 20.12.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Combine

final class MainViewModel {

    private let provider: DependencyProvider

    private var router: MainRouter!

    private var cancellables: [AnyCancellable] = []

    init(provider: DependencyProvider) {
        self.provider = provider
    }

    func inject(router: MainRouter) {
        self.router = router
    }
}
