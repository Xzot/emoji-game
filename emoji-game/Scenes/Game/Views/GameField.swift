//
//  GameField.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit
import Combine
import SkeletonView
import TinyConstraints

// MARK: - GameField class
final class GameField: UIView {
    // MARK: Properties
    private let spacing: CGFloat
    private let viewModel: GameViewModel
    
    // MARK: UI
    private lazy var topPanel = GameOptionsPanel(
        spacing: spacing,
        leftImage: viewModel.topLeftImage,
        centerImage: viewModel.topCenterImage,
        rightImage: viewModel.topRightImage
    )
    
    // MARK: Life Cycle
    init(spacing: CGFloat, viewModel: GameViewModel) {
        self.spacing = spacing
        self.viewModel = viewModel
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
