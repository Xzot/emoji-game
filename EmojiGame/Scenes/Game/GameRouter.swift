//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit

// MARK: - GameRouter class
final class GameRouter {
    // MARK: Properties
    private(set) weak var presentable: GameViewController?
    private let finalSceneBuilder: FinalBuilder

    // MARK: Life Cycle
    init(
        presentable: GameViewController,
        finalSceneBuilder: FinalBuilder
    ) {
        self.presentable = presentable
        self.finalSceneBuilder = finalSceneBuilder
    }
    
    func routeToGameOverScene() {
        let gemaOverScene = finalSceneBuilder.build(
            listener: presentable?.viewModel,
            type: .gameover
        )
        presentable?.navigationController?.pushViewController(
            gemaOverScene,
            animated: false
        )
    }
    
    func routeToPauseScene() {
        guard presentable?.navigationController?.viewControllers.last == presentable else {
            return
        }
        let pauseScene = finalSceneBuilder.build(
            listener: presentable?.viewModel,
            type: .pause
        )
        presentable?.navigationController?.pushViewController(
            pauseScene,
            animated: false
        )
    }
}
