//
//  Created by Vlad Shchuka on 20.12.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - MainRouter class
final class MainRouter {
    // MARK: Properties
    private weak var presentable: MainViewController?
    
    // MARK: Life Cycle
    init(presentable: MainViewController) {
        self.presentable = presentable
    }
}
