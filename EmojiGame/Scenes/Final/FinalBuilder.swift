//
//  Created by Vlad Shchuka on 11.01.2022.
//

import UIKit

// MARK: - FinalBuilder class
final class FinalBuilder {
    // MARK: Properties
    private let provider: DependencyProvider

    // MARK: Life Cycle
    init(provider: DependencyProvider) {
        self.provider = provider
    }

    // MARK: API
    func build(listener: FinalListener?, type: FinalBuilder.SceneType) -> UIViewController {
        let viewModel = FinalViewModel(provider: provider, listener: listener)
        let viewController = FinalViewController(
            viewModel: viewModel,
            sceneType: type.vcType
        )
        let router = FinalRouter(presentable: viewController)
        viewModel.inject(router: router)
        
        return viewController
    }
}

// MARK: - SceneType
extension FinalBuilder {
    enum SceneType {
        case pause
        case gameover
        
        var vcType: FinalViewController.SceneType {
            switch self {
            case .pause:
                return .pause
            case .gameover:
                return .gameover
            }
        }
    }
}
