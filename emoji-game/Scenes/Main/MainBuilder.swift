//
//  Created by Vlad Shchuka on 20.12.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - MainBuilder class
final class MainBuilder {
    // MARK: Properties
    private let provider: DependencyProvider

    // MARK: Life Cycle
    init(provider: DependencyProvider) {
        self.provider = provider
    }

    func build() -> UIViewController {
        let viewModel = MainViewModel(provider: provider)
        let viewController = MainViewController(viewModel: viewModel)
        let gameSceneBuilder = GameBuilder(provider: provider)
        let router = MainRouter(
            presentable: viewController,
            gameSceneBuilder: gameSceneBuilder
        )
        viewModel.inject(router: router)
        return viewController
    }
}
