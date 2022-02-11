//
//  Created by Vlad Shchuka on 11.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - SceneType
extension FinalViewController {
    enum SceneType {
        case pause
        case gameover
        
        var titleText: String {
            switch self {
            case .pause:
                return "Paused"
            case .gameover:
                return "Time is Over"
            }
        }
        
        var image: UIImage {
            switch self {
            case .pause:
                return Asset.Images.finishPause.image
            case .gameover:
                return Asset.Images.finishGameOver.image
            }
        }
    }
}

// MARK: - FinalViewController class
final class FinalViewController: UIViewController {
    // MARK: Properties
    private let sceneType: FinalViewController.SceneType
    private let viewModel: FinalViewModel
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: UI
    private lazy var imageView = UIImageView(
        image: sceneType.image
    )&>.do {
        $0.contentMode = .center
    }
    private lazy var descriptionLabel = UILabel()&>.do {
        $0.textColor = Asset.Palette.black.color
        $0.textAlignment = .center
        $0.text = sceneType.titleText
        $0.font = .quicksand(
            ofSize: max(44, 50 * UIDevice.sizeFactor),
            weight: .bold
        )
    }
    private lazy var scoreLabel = UILabel()&>.do {
        $0.textColor = Asset.Palette.black.color
        $0.textAlignment = .center
        $0.font = .quicksand(
            ofSize: max(20, 24 * UIDevice.sizeFactor),
            weight: .bold
        )
    }
    private lazy var bottomBar = FinalSceneBar(completion: handle(action:))
    
    // MARK: Life Cycle
    init(
        viewModel: FinalViewModel,
        sceneType: FinalViewController.SceneType
    ) {
        self.viewModel = viewModel
        self.sceneType = sceneType
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = Asset.Palette.white.color
        
        view.addSubview(imageView)
        imageView.topToSuperview(usingSafeArea: true)
        imageView.horizontalToSuperview()
        imageView.height(
            to: view,
            multiplier: 0.4
        )
        
        view.addSubview(descriptionLabel)
        descriptionLabel.topToBottom(of: imageView)
        descriptionLabel.horizontalToSuperview()
        
        view.addSubview(scoreLabel)
        scoreLabel.topToBottom(of: descriptionLabel, offset: 4)
        scoreLabel.horizontalToSuperview()
        
        view.addSubview(bottomBar)
        let insetValue: CGFloat = max(16, 24 * UIDevice.sizeFactor)
        bottomBar.horizontalToSuperview(insets: .left(insetValue) + .right(insetValue))
        bottomBar.bottomToSuperview(usingSafeArea: true)
        bottomBar.height(to: view, multiplier: 0.28)
        
        viewModel.scorePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.scoreLabel.text = "Your Score: " + String(value)
            }
            .store(in: &self.cancellable)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - FinalViewController private
private extension FinalViewController {
    func handle(action: FinalSceneBar.Action) {
        switch action {
        case .giveUp:
            viewModel.userTapGameOver()
        case .tryAgain:
            viewModel.userTapContinue()
        }
    }
}
