//
//  AnimatedPlayButton.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - AnimatedPlayButton class
final class AnimatedPlayButton: UIView {
    // MARK: UI
    private lazy var button = PlayButton(
        score: score,
        delegate: delegate
    )
    
    // MARK: Properties
    private let score: AnyPublisher<Int, Never>
    private weak var delegate: PlayButtonDelegate!
    
    // MARK: Life Cycle
    init(
        cRadius: CGFloat,
        score: AnyPublisher<Int, Never>,
        delegate: PlayButtonDelegate
    ) {
        self.score = score
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        addSubview(button)
        button.edgesToSuperview()
        button.clipsToBounds = true
        button.layer.cornerRadius = cRadius
        
        let aConfig = AppConstants.MainScene.PulseAnimation()
        button.pulseAnimated(
            minScale: aConfig.minScale,
            maxScale: aConfig.maxScale,
            duration: aConfig.duration,
            delay: aConfig.delay
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Highlighting when in touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        alpha = 0.7
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        alpha = 1
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        alpha = 1
    }
}
