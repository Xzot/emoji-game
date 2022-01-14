//
//  Created by Vlad Shchuka on 20.12.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Combine
import UIKit

// MARK: - StartViewModel final class
final class StartViewModel {
    // MARK: Output
    var isReadyToShowNextScenePublisher: AnyPublisher<Bool, Never> {
        isReadyToShowNextSceneSubject.eraseToAnyPublisher()
    }
    
    // MARK: Properties
    private let provider: DependencyProvider
    private var router: StartRouter!
    private let adService: AppAdService
    private var cancellables: [AnyCancellable] = []
    private let isReadyToShowNextSceneSubject = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: Life Cycle
    init(provider: DependencyProvider) {
        self.provider = provider
        self.adService = provider.get(AppAdService.self)
    }
    
    // MARK: Public
    func inject(router: StartRouter) {
        self.router = router
    }
    
    func handleViewDidLoad() {
        adService.prefetchAds()
        isReadyToShowNextSceneSubject.send(true)
    }
    
    func routeToNextScene() {
        router.routeToNextScene()
    }
}
