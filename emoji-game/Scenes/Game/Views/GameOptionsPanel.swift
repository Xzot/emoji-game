//
//  GameOptionsPanel.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - GameOptionsPanel class
final class GameOptionsPanel: UIView {
    // MARK: Properties
    private let spacing: CGFloat
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: UI
    private lazy var stackView = UIStackView()&>.do {
        $0.spacing = spacing
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    // MARK: Life Cycle
    init(
        spacing: CGFloat,
        leftImage: ImagePublisher,
        centerImage: ImagePublisher,
        rightImage: ImagePublisher
    ) {
        self.spacing = spacing
        
        super.init(frame: .zero)
        
        addSubview(stackView)
        stackView.edgesToSuperview()
        
        bind(
            leftImage: leftImage,
            centerImage: centerImage,
            rightImage: rightImage
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GameOptionsPanel {
    func bind(
        leftImage: ImagePublisher,
        centerImage: ImagePublisher,
        rightImage: ImagePublisher
    ) {
        leftImage
            .receive(on: DispatchQueue.main)
            .sink { value in
                
            }
            .store(in: &cancellable)
        
        centerImage
            .receive(on: DispatchQueue.main)
            .sink { value in
                
            }
            .store(in: &cancellable)
        
        rightImage
            .receive(on: DispatchQueue.main)
            .sink { value in
                
            }
            .store(in: &cancellable)
    }
}
