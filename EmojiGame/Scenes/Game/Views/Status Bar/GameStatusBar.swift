//
//  GameStatusBar.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit
import TinyConstraints

// MARK: - GameStatusBar class
final class GameStatusBar: UIView {
    // MARK: Properties
    private let viewModel: GameViewModel
    
    // MARK: UI
    private lazy var pauseButton = ImageButton(
        config: ImageButtonConfig(Asset.Images.gamePause.image)
    ) { [weak self] in
        self?.viewModel.handlePause(withSound: true)
    }
    private lazy var scoreLabel = GameScoreLabel(viewModel.score)
    private lazy var timerLabel = GameTimerLabel(viewModel.time)
    
    // MARK: Life Cycle
    init(_ viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        addSubview(pauseButton)
        pauseButton.centerYToSuperview()
        pauseButton.leftToSuperview(offset: 16)
        pauseButton.size(CGSize(width: 40, height: 40))
        
        addSubview(scoreLabel)
        scoreLabel.verticalToSuperview()
        pauseButton.rightToLeft(of: scoreLabel, offset: -16)
        
        guard viewModel.gameType == .timeAttack else {
            return
        }
        addSubview(timerLabel)
        timerLabel.verticalToSuperview()
        timerLabel.rightToSuperview()
        timerLabel.widthToSuperview(multiplier: 0.3)
        
        scoreLabel.rightToLeft(of: timerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
