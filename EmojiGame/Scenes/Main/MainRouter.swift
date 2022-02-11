//
//  Created by Vlad Shchuka on 20.12.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - MainRouter class
final class MainRouter {
    // MARK: Properties
    private weak var presentable: MainViewController?
    private let gameSceneBuilder: GameBuilder
    
    // MARK: Life Cycle
    init(
        presentable: MainViewController,
        gameSceneBuilder: GameBuilder
    ) {
        self.presentable = presentable
        self.gameSceneBuilder = gameSceneBuilder
    }
    
    // MARK: API
    func makeGameSceneRoute() {
        let gameScene = gameSceneBuilder.build(listener: nil)
        presentable?.navigationController?.pushViewController(
            gameScene,
            animated: false
        )
    }
}
