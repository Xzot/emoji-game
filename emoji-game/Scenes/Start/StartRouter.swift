//
//  Created by Vlad Shchuka on 20.12.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - StartRouter class
final class StartRouter {
    // MARK: Properties
    private weak var presentable: StartViewController?
    private let builder: MainBuilder

    // MARK: Life Cycle
    init(presentable: StartViewController, builder: MainBuilder) {
        self.presentable = presentable
        self.builder = builder
    }
    
    func routeToNextScene() {
        presentable?.swapCurrentChild(with:  builder.build())
    }
}
