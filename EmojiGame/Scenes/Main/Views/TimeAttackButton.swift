//
//  TimeAttackButton.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - TimeAttackButton class
final class TimeAttackButton: UIView, SelectableTransform {
    // MARK: UI
    private lazy var backgroundView = UIView()&>.do {
        $0.backgroundColor = Asset.Palette.royalBlue.color
    }
    private lazy var absorbingView = TimeAttackContentView(scorePublisher)
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
        
        addSubview(absorbingView)
        absorbingView.centerInSuperview()
        absorbingView.horizontalToSuperview(usingSafeArea: true)
        
        addSubview(button)
        button.edgesToSuperview()
        
        layer.cornerRadius = max(16, 18 * UIDevice.sizeFactor)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension TimeAttackButton {
    @objc
    func handleButtonTap() {
        completion()
    }
}
