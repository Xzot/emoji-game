//
//  PlayButton.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - PlayButtonDelegate
protocol PlayButtonDelegate: NSObject {
    func didTap()
}

// MARK: - PlayButton class
final class PlayButton: UIView {
    // MARK: UI
    private lazy var absorbingView = PBAbsorbingView(scorePublisher)
    
    // MARK: Properties
    private weak var delegate: PlayButtonDelegate?
    private let tapGestureRecognaizer = UITapGestureRecognizer(
        target: self,
        action: #selector(handleTapp)
    )
    private let scorePublisher: AnyPublisher<Int, Never>
    
    // MARK: Life Cycle
    init(
        score: AnyPublisher<Int, Never>,
        delegate: PlayButtonDelegate
    ) {
        self.scorePublisher = score
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        backgroundColor = Asset.Palette.jungleGreen.color
        
        addSubview(absorbingView)
        absorbingView.centerInSuperview()
        absorbingView.horizontalToSuperview(usingSafeArea: true)
        
        addGestureRecognizer(tapGestureRecognaizer)
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

// MARK: - PlayButton extension
private extension PlayButton {
    @objc
    func handleTapp() {
        delegate?.didTap()
    }
}
