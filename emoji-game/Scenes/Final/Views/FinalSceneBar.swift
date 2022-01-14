//
//  FinalSceneBar.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 12.01.2022.
//

import UIKit
import TinyConstraints

// MARK: - Action
extension FinalSceneBar {
    enum Action {
        case giveUp
        case tryAgain
    }
}

// MARK: - FinalSceneBar class
final class FinalSceneBar: UIView {
    // MARK: Properties
    private var completion: (FinalSceneBar.Action) -> Void
    
    // MARK: UI
    private lazy var stackView = UIStackView()&>.do {
        $0.spacing = 16
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    private lazy var continueButton = ContinueButton(
        completion: { [weak self] in
            self?.completion(.tryAgain)
        }
    )
    private lazy var gameOverButton = GameOverButton(
        completion: { [weak self] in
            self?.completion(.giveUp)
        }
    )
    
    // MARK: Life Cycle
    init(completion: @escaping (FinalSceneBar.Action) -> Void) {
        self.completion = completion
        
        super.init(frame: .zero)
        
        addSubview(stackView)
        stackView.horizontalToSuperview()
        stackView.topToSuperview(offset: max(16, 24 * UIDevice.sizeFactor))
        stackView.bottomToSuperview(offset: -max(40, 56 * UIDevice.sizeFactor))
        
        stackView.addArrangedSubview(continueButton)
        stackView.addArrangedSubview(gameOverButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
