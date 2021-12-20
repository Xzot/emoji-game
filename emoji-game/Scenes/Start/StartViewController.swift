//
//  Created by Vlad Shchuka on 20.12.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Combine
import RevealingSplashView

// MARK: - StartViewController class
final class StartViewController: UIViewController {
    // MARK: Properties
    private let viewModel: StartViewModel
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: UI
    private lazy var revealingSplashView = RevealingSplashView(
        iconImage: Asset.Images.launchScreen.image,
        iconInitialSize: CGSize(width: 172, height: 138),
        backgroundColor: Asset.Palette.jungleGreen.color
    )
    
    // MARK: Life Cycle
    init(viewModel: StartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Asset.Palette.jungleGreen.color
        
        revealingSplashView.animationType = .heartBeat
        view.addSubview(revealingSplashView)
        
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.handleViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        revealingSplashView.startAnimation() { [weak self] in
            self?.viewModel.routeToNextScene()
        }
    }
}

// MARK: - StartViewController private
private extension StartViewController {
    func bind() {
        viewModel.isReadyToShowNextScenePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] canShowNext in
                guard canShowNext == true else {
                    return
                }
                self?.revealingSplashView.heartAttack = true
            }
            .store(in: &cancellable)
    }
}
