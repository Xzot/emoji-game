//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit

// MARK: - GameRouter class
final class GameRouter {
    // MARK: Properties
    private weak var presentable: GameViewController?

    // MARK: Life Cycle
    init(presentable: GameViewController) {
        self.presentable = presentable
    }
}
