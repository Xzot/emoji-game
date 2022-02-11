//
//  GameOverButton.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 14.01.2022.
//

import UIKit

import UIKit
import Combine
import TinyConstraints

// MARK: - GameOverButton class
final class GameOverButton: UIView, SelectableTransform {
    // MARK: Properties
    private var completion: VoidCompletion
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: UI
    private lazy var button = UIButton()&>.do {
        $0.publisher(for: \.isHighlighted)
            .sink(receiveValue: { [weak self] value in
                self?.setIsHighlighted(value)
            })
            .store(in: &cancellable)
        $0.addTarget(
            self,
            action: #selector(handleButtonTap),
            for: .touchUpInside
        )
    }
    private lazy var titleLable = UILabel()&>.do {
        $0.textColor = Asset.Palette.black.color
        $0.text = Strings.FinalScene.gameOverButtonTitle
        $0.font = .quicksand(
            ofSize: max(28, 32 * UIDevice.sizeFactor),
            weight: .bold
        )
        $0.textAlignment = .center
    }
    
    // MARK: Life Cycle
    init(completion: @escaping VoidCompletion) {
        self.completion = completion
        
        super.init(frame: .zero)
        
        backgroundColor = Asset.Palette.white.color
        
        addSubview(titleLable)
        titleLable.centerYToSuperview()
        titleLable.horizontalToSuperview()
        
        addSubview(button)
        button.edgesToSuperview()
        
        layer.cornerRadius = 20
        layer.borderWidth = 4
        layer.borderColor = Asset.Palette.gallery.color.cgColor
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension GameOverButton {
    @objc
    func handleButtonTap() {
        completion()
    }
}
