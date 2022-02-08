//
//  Created by Vlad Shchuka on 20.12.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - StartViewController class
final class StartViewController: SwapChildViewController {
    // MARK: Properties
    private let viewModel: StartViewModel
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: UI
    private lazy var imageView = UIImageView(
        image: Asset.Images.launchScreen.image
    )&>.do {
        $0.contentMode = .center
    }
    
    // MARK: Life Cycle
    init(viewModel: StartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = Asset.Palette.jungleGreen.color
        
        view.addSubview(imageView)
        imageView.centerInSuperview()
        
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
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
                self?.viewModel.routeToNextScene()
            }
            .store(in: &cancellable)
    }
}
