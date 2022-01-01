//
//  Created by Vlad Shchuka on 20.12.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class StartBuilder {
    private let provider: DependencyProvider

    init(provider: DependencyProvider) {
        self.provider = provider
    }

    func build() -> UIViewController {
        let viewModel = StartViewModel(provider: provider)
        let viewController = StartViewController(viewModel: viewModel)
        let bilder = MainBuilder(provider: provider)
        let router = StartRouter(
            presentable: viewController,
            builder: bilder
        )
        viewModel.inject(router: router)
        return viewController
    }
}
