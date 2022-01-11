//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit

// MARK: - GameRouter class
final class GameRouter {
    // MARK: Properties
    private weak var presentable: GameViewController?
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
            listener: nil,
            type: .gameover
        )
        presentable?.navigationController?.pushViewController(
            gemaOverScene,
            animated: false
        )
    }
    
    func routeToPauseScene() {
        let pauseScene = finalSceneBuilder.build(
            listener: nil,
            type: .pause
        )
        presentable?.navigationController?.pushViewController(
            pauseScene,
            animated: false
        )
    }
}
