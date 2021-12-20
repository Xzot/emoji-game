//
//  Created by Vlad Shchuka on 20.12.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class MainBuilder {
    private let provider: DependencyProvider

    init(provider: DependencyProvider) {
        self.provider = provider
    }

    func build() -> UIViewController {
        let viewModel = MainViewModel(provider: provider)
        let viewController = MainViewController(viewModel: viewModel)
        let router = MainRouter(presentable: viewController)
        viewModel.inject(router: router)
        return viewController
    }
}
