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
    
    // MARK: UI
    private lazy var imageView = UIImageView(
        image: sceneType.image
    )&>.do {
        $0.contentMode = .center
    }
    private lazy var label = UILabel()&>.do {
        $0.textColor = Asset.Palette.black.color
        $0.textAlignment = .center
        $0.text = sceneType.titleText
        $0.font = .quicksand(
            ofSize: max(44, 50 * UIDevice.sizeFactor),
            weight: .bold
        )
    }
    
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
        
        view.addSubview(label)
        label.topToBottom(of: imageView)
        label.centerXToSuperview()
        label.horizontalToSuperview(
            relation: .equalOrGreater,
            usingSafeArea: true
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
