//
//  Created by Vlad Shchuka on 20.12.2021.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - MainViewController class
final class MainViewController: SwapChildViewController {
    // MARK: Properties
    private let viewModel: MainViewModel
    
    // MARK: UI
    private lazy var imageView = UIImageView(image: Asset.Images.startHeader.image)&>.do {
        $0.contentMode = .scaleAspectFill
    }
    private lazy var label = UILabel()&>.do {
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.text = Strings.MainScene.labelText
        $0.font = .quicksand(
            ofSize: max(48, 56 * UIDevice.sizeFactor),
            weight: .bold
        )
    }
    private lazy var gameBar = PlaySceneBar(
        score: viewModel.scoreOutut,
        delegate: self
    )
    
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
        imageView.height(to: view, multiplier: 0.34)
        
        view.addSubview(label)
        label.topToBottom(of: imageView)
        label.centerXToSuperview()
        label.horizontalToSuperview(
            relation: .equalOrGreater,
            usingSafeArea: true
        )
        
        let aConfig = AppConstants.MainScene.PulseAnimation()
        label.pulseAnimated(
            minScale: aConfig.minScale,
            maxScale: aConfig.maxScale,
            duration: aConfig.duration,
            delay: aConfig.delay
        )
        
        view.addSubview(gameBar)
        gameBar.edgesToSuperview(excluding: .top)
        gameBar.topToBottom(of: label)
    }
}

// MARK: - PlaySceneBarDelegate extension
extension MainViewController: PlaySceneBarDelegate {
    func didTapPlay() {
        viewModel.playTapped()
    }
    
    func didTapAds() {
        
    }
    
    func didTapSound() {
        
    }
}
