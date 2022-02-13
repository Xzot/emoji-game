//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit

// MARK: - GameBuilder class
final class GameBuilder {
    // MARK: GameType enum
    enum GameType {
        case infinite
        case timeAttack
    }
    
    // MARK: Properties
    private let provider: DependencyProvider
    
    // MARK: Life Cycle
    init(provider: DependencyProvider) {
        self.provider = provider
    }
    
    // MARK: API
    func build(_ type: GameBuilder.GameType, listener: GameListener?) -> UIViewController {
        let viewModel = GameViewModel(
            gameType: type == .infinite ? .infinite : .timeAttack,
            provider: provider,
            listener: listener
        )
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
