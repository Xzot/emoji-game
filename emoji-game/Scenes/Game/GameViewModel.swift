//
//  Created by Vlad Shchuka on 02.01.2022.
//

import Combine

// MARK: - GameListener protocol
protocol GameListener: AnyObject {}

// MARK: - GameViewModel class
final class GameViewModel {
    // MARK: Output
    // Top
    var topLeftImage: ImagePublisher {
        topLeftImageState.eraseToAnyPublisher()
    }
    var topCenterImage: ImagePublisher {
        topCenterImageState.eraseToAnyPublisher()
    }
    var topRightImage: ImagePublisher {
        topRightImageState.eraseToAnyPublisher()
    }
    
    // Center
    var centerImage: ImagePublisher {
        centerImageState.eraseToAnyPublisher()
    }
    
    // Bottom
    var bottomLeftImage: ImagePublisher {
        bottomLeftImageState.eraseToAnyPublisher()
    }
    var bottomCenterImage: ImagePublisher {
        bottomCenterImageState.eraseToAnyPublisher()
    }
    var bottomRightImage: ImagePublisher {
        bottomRightImageState.eraseToAnyPublisher()
    }
    
    // MARK: Properties
    private let provider: DependencyProvider
    private var router: GameRouter!
    private weak var listener: GameListener?
    // Top
    private let topLeftImageState = ImageState(nil)
    private let topCenterImageState = ImageState(nil)
    private let topRightImageState = ImageState(nil)
    // Center
    private let centerImageState = ImageState(nil)
    // Bottom
    private let bottomLeftImageState = ImageState(nil)
    private let bottomCenterImageState = ImageState(nil)
    private let bottomRightImageState = ImageState(nil)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    init(
        provider: DependencyProvider,
        listener: GameListener?
    ) {
        self.provider = provider
        self.listener = listener
    }
    
    // MARK: API
    func inject(router: GameRouter) {
        self.router = router
    }
}
