//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - GameViewController class
final class GameViewController: UIViewController {
    // MARK: Properties
    private let viewModel: GameViewModel
    
    // MARK: UI
    
    private lazy var gameField = UIView()
    
    // MARK: Life Cycle
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = Asset.Palette.white.color
        
        view.addSubview(gameField)
        gameField.horizontalToSuperview()
        gameField.bottomToSuperview(usingSafeArea: true)
        gameField.height(to: view, multiplier: 0.825)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
