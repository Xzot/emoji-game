//
//  GameField.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - GameField class
final class GameField: UIView {
    // MARK: Properties
    private let spacing: CGFloat
    private let numberOfItemsInBar: CGFloat
    private let viewModel: GameViewModel
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.size.width
    }
    
    // MARK: UI
    private lazy var topPanel = GameOptionsPanel(
        spacing: spacing,
        leftImage: viewModel.topLeftImage,
        centerImage: viewModel.topCenterImage,
        rightImage: viewModel.topRightImage
    )
    private lazy var mixedEmojiView = ImageView(
        image: viewModel.centerImage,
        type: .embded
    )
    private lazy var bottomPanel = GameOptionsPanel(
        spacing: spacing,
        leftImage: viewModel.bottomLeftImage,
        centerImage: viewModel.bottomCenterImage,
        rightImage: viewModel.bottomRightImage
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
        
        addSubview(bottomPanel)
        bottomPanel.height(barHeight)
        bottomPanel.horizontalToSuperview(insets: .left(spacing) + .right(spacing))
        bottomPanel.bottomToSuperview(offset: -verticalOffset)
        
        addSubview(mixedEmojiView)
        let emojiOffset: CGFloat = max(18, 24 * UIDevice.sizeFactor)
        mixedEmojiView.horizontalToSuperview(insets: .left(emojiOffset) + .right(emojiOffset))
        mixedEmojiView.topToBottom(of: topPanel, offset: emojiOffset)
        mixedEmojiView.bottomToTop(of: bottomPanel, offset: -emojiOffset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}