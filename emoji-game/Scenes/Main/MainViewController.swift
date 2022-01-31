//
//  Created by Vlad Shchuka on 20.12.2021.
//

import Gifu
import UIKit
import Combine
import TinyConstraints

// MARK: - MainViewController class
final class MainViewController: SwapChildViewController {
    // MARK: Properties
    private let viewModel: MainViewModel
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: UI
    private lazy var imageView = GIFImageView(
        image: Asset.Images.startHeader.image
    )&>.do {
        $0.contentMode = .scaleAspectFit
    }
    private lazy var label = UILabel()&>.do {
        $0.textColor = Asset.Palette.black.color
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.text = Strings.MainScene.labelText
        $0.font = .quicksand(
            ofSize: max(48, 56 * UIDevice.sizeFactor),
            weight: .bold
        )
    }
    private lazy var gameBar = PlaySceneBar(viewModel: viewModel)
    private lazy var restoreButton = UIButton()&>.do {
        $0.titleLabel?.font = .quicksand(
            ofSize: 17,
            weight: .bold
        )
        $0.setTitleColor(
            Asset.Palette.black.color,
            for: .normal
        )
        $0.setTitle(
            "Restore purchase",
            for: .normal
        )
        $0.addTarget(
            self,
            action: #selector(handleButtonTap),
            for: .touchUpInside
        )
    }
    
    // MARK: Life Cycle
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Asset.Palette.white.color
        
        view.addSubview(imageView)
        imageView.topToSuperview(usingSafeArea: true)
        imageView.horizontalToSuperview()
        imageView.height(
            to: view,
            multiplier: AppConstants.MainScene.gifMultiplier
        )
        
        view.addSubview(label)
        label.topToBottom(of: imageView)
        label.centerXToSuperview()
        label.horizontalToSuperview(
            relation: .equalOrGreater,
            usingSafeArea: true
        )
        
        view.addSubview(gameBar)
        gameBar.edgesToSuperview(excluding: .top)
        gameBar.topToBottom(of: label)
        
        imageView.prepareForAnimation(
            withGIFNamed: "main_emojis",
            completionHandler: nil
        )
        
        view.addSubview(restoreButton)
        restoreButton.size(CGSize(width: 160, height: 40))
        restoreButton.topToSuperview(usingSafeArea: true)
        restoreButton.leftToSuperview(offset: 16, usingSafeArea: true)
        
        viewModel.isAdsHiddenOutput
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.restoreButton.isHidden = value
            }
            .store(in: &cancellable)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.startAnimatingGIF()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imageView.stopAnimatingGIF()
    }
}

// MARK: - Private
private extension MainViewController {
    @objc
    func handleButtonTap() {
        viewModel.restoreNoAdsTapped()
    }
}
