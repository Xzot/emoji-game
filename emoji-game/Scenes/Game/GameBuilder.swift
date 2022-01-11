//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit

// MARK: - GameBuilder class
final class GameBuilder {
    // MARK: Properties
    private let provider: DependencyProvider

    // MARK: Life Cycle
    init(provider: DependencyProvider) {
        self.provider = provider
    }

    // MARK: API
    func build(listener: GameListener?) -> UIViewController {
        let viewModel = GameViewModel(provider: provider, listener: listener)
        let viewController = GameViewController(viewModel: viewModel)
        let finalSceneBuilder = FinalBuilder(provider: provider)
        let router = GameRouter(
            presentable: viewController,
            finalSceneBuilder: finalSceneBuilder
        )
        viewModel.inject(router: router)
        return viewController
    }
}
