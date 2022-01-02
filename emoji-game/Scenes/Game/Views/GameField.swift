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
    private let numberOfItemsInBar: CGFloat
    private let viewModel: GameViewModel
    private var screenWidth: CGFloat {
        window?.frame.size.width ?? 0
    }
    
    // MARK: UI
    private lazy var topPanel = GameOptionsPanel(
        spacing: spacing,
        leftImage: viewModel.topLeftImage,
        centerImage: viewModel.topCenterImage,
        rightImage: viewModel.topRightImage
    )
    
    // MARK: Life Cycle
    init(
        spacing: CGFloat,
        numberOfItemsInBar: CGFloat,
        viewModel: GameViewModel
    ) {
        self.spacing = spacing
        self.numberOfItemsInBar = numberOfItemsInBar
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        let verticalOffset: CGFloat = max(40, 56 * UIDevice.sizeFactor)
        let barHeight: CGFloat = (screenWidth - (spacing * (numberOfItemsInBar + 1))) / numberOfItemsInBar
        addSubview(topPanel)
        topPanel.height(barHeight)
        topPanel.horizontalToSuperview(insets: .left(spacing) + .right(spacing))
        topPanel.topToSuperview(offset: verticalOffset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
