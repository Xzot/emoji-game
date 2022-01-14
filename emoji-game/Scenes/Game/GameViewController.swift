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
    private let spacing: CGFloat = 16
    private let numberOfItemsInBar: CGFloat = 3
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    // MARK: UI
    private lazy var gameStatusBar = GameStatusBar(viewModel)
    private lazy var gameField = GameField(
        spacing: spacing,
        numberOfItemsInBar: numberOfItemsInBar,
        viewModel: viewModel
    )
    
    // MARK: Life Cycle
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = Asset.Palette.white.color
        
        view.addSubview(gameField)
        gameField.horizontalToSuperview()
        gameField.bottomToSuperview(usingSafeArea: true)
        gameField.height(to: view, multiplier: 0.825)
        
        view.addSubview(gameStatusBar)
        gameStatusBar.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        gameStatusBar.bottomToTop(of: gameField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
}
