//
//  Created by Vlad Shchuka on 11.01.2022.
//

import UIKit

// MARK: - FinalRouter class
final class FinalRouter {
    // MARK: Properties
    private weak var presentable: FinalViewController?

    // MARK: Life Cycle
    init(presentable: FinalViewController) {
        self.presentable = presentable
    }
}
