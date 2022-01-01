//
//  PlaySceneBar.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - PlaySceneBarDelegate
protocol PlaySceneBarDelegate: NSObject {
    func didTapPlay()
    func didTapAds()
    func didTapSound()
}

// MARK: - PlaySceneBar class
final class PlaySceneBar: UIView {
    // MARK: UI
    private lazy var playButton = AnimatedPlayButton(
        cRadius: playButtonSize / 2,
        score: scorePublisher,
        delegate: self
    )
    
    // MARK: Properties
    private weak var delegate: PlaySceneBarDelegate?
    private let scorePublisher: AnyPublisher<Int, Never>
    private var playButtonSize: CGFloat {
        max(160, 196 * UIDevice.sizeFactor)
    }
    
    // MARK: Life Cycle
    init(score: AnyPublisher<Int, Never>, delegate: PlaySceneBarDelegate) {
        self.scorePublisher = score
        self.delegate = delegate
        super.init(frame: .zero)
        
        addSubview(playButton)
        playButton.size(
            CGSize(
                width: playButtonSize,
                height: playButtonSize
            )
        )
        playButton.centerXToSuperview()
        playButton.topToSuperview(offset: max(30, 40 * UIDevice.sizeFactor))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - PlayButtonDelegate
extension PlaySceneBar: PlayButtonDelegate {
    func didTap() {
        delegate?.didTapPlay()
    }
}
