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
    private var leftImage: ImagePublisher
    private var centerImage: ImagePublisher
    private var rightImage: ImagePublisher
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: UI
    private lazy var stackView = UIStackView()&>.do {
        $0.spacing = spacing
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    private lazy var leftImageView = ShimmerImageView(image: leftImage)
    private lazy var centerImageView = ShimmerImageView(image: centerImage)
    private lazy var rightImageView = ShimmerImageView(image: rightImage)
    
    // MARK: API
    func update(
        leftImage: ImagePublisher,
        centerImage: ImagePublisher,
        rightImage: ImagePublisher
    ) {
        self.leftImage = leftImage
        self.centerImage = centerImage
        self.rightImage = rightImage
        
        leftImageView.update(leftImage)
        centerImageView.update(centerImage)
        rightImageView.update(rightImage)
    }
    
    // MARK: Life Cycle
    init(
        spacing: CGFloat,
        leftImage: ImagePublisher,
        centerImage: ImagePublisher,
        rightImage: ImagePublisher
    ) {
        self.spacing = spacing
        self.leftImage = leftImage
        self.centerImage = centerImage
        self.rightImage = rightImage
        
        super.init(frame: .zero)
        
        addSubview(stackView)
        stackView.edgesToSuperview()
        
        stackView.addArrangedSubview(leftImageView)
        stackView.addArrangedSubview(centerImageView)
        stackView.addArrangedSubview(rightImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
