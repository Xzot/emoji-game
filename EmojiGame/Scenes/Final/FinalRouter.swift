//
//  Created by Vlad Shchuka on 11.01.2022.
//

import UIKit

// MARK: - FinalRouter class
final class FinalRouter {
    // MARK: Properties
    private(set) weak var presentable: FinalViewController?

    // MARK: Life Cycle
    init(presentable: FinalViewController) {
        self.presentable = presentable
    }
    
    func routeToMain() {
        guard let mainScene = presentable?.navigationController?.viewControllers
                .filter({ $0.isKind(of: MainViewController.self) })
                .first else { return }
        presentable?.navigationController?.popToViewController(
            mainScene,
            animated: false
        )
    }
    
    func routeBack() {
        presentable?.navigationController?.popViewController(animated: false)
    }
}
