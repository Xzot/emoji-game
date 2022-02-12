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
    private(set) lazy var topPanel = GameOptionsPanel(
        spacing: spacing,
        leftPublisher: viewModel.topLeft,
        centerPublisher: viewModel.topCenter,
        rightPublisher: viewModel.topRight
    )
    private(set) lazy var mixedEmojiView = ImageView(
        image: viewModel.centerImage,
        type: .embded
    )
    private(set) lazy var bottomPanel = GameOptionsPanel(
        spacing: spacing,
        leftPublisher: viewModel.bottomLeft,
        centerPublisher: viewModel.bottomCenter,
        rightPublisher: viewModel.bottomRight
    )
    
    // MARK: - API
    func animateAsDone(_ completion: @escaping () -> Void) {
        mixedEmojiView.expandAnimated(
            with: AppConstants.Animation.longDuration,
            and: AppConstants.Animation.delay
        ) { [weak self] in
            guard let `self` = self else { return }
            self.mixedEmojiView.backToNormalAnimated(
                with: AppConstants.Animation.longDuration,
                and: AppConstants.Animation.shortDelay
            ) {
                completion()
            }
        }
    }
    
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
