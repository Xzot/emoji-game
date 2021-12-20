//
//  Created by Vlad Shchuka on 20.12.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class MainRouter {
    private weak var presentable: MainViewController?

    init(presentable: MainViewController) {
        self.presentable = presentable
    }
}
