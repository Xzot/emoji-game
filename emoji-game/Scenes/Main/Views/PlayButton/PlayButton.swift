//
//  PlayButton.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - PlayButton class
final class PlayButton: UIView, SelectableTransform {
    // MARK: UI
    private lazy var backgroundView = UIView()&>.do {
        $0.backgroundColor = Asset.Palette.jungleGreen.color
    }
    private lazy var absorbingView = PBAbsorbingView(scorePublisher)
    private lazy var button = UIButton()&>.do {
        $0.publisher(for: \.isHighlighted)
            .sink(receiveValue: setIsHighlighted(_:))
            .store(in: &cancellable)
        $0.addTarget(
            self,
            action: #selector(handleButtonTap),
            for: .touchUpInside
        )
    }
    
    // MARK: Properties
    private let completion: VoidCompletion
    private let scorePublisher: AnyPublisher<Int, Never>
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    init(
        score: AnyPublisher<Int, Never>,
        completion: @escaping VoidCompletion
    ) {
        self.scorePublisher = score
        self.completion = completion
        
        super.init(frame: .zero)
        
        addSubview(backgroundView)
        backgroundView.edgesToSuperview()
        backgroundView.layer.cornerRadius = AppConstants.MainScene.playButtonSize / 2
        
        addSubview(absorbingView)
        absorbingView.centerInSuperview()
        absorbingView.horizontalToSuperview(usingSafeArea: true)
        
        addSubview(button)
        button.edgesToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension PlayButton {
    @objc
    func handleButtonTap() {
        completion()
    }
}
