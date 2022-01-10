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
    private let leftPublisher: GOPIVMPublisher
    private let centerPublisher: GOPIVMPublisher
    private let rightPublisher: GOPIVMPublisher
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: UI
    private lazy var stackView = UIStackView()&>.do {
        $0.spacing = spacing
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    private lazy var leftImageView = GOPItemView(publisher: leftPublisher)
    private lazy var centerImageView = GOPItemView(publisher: centerPublisher)
    private lazy var rightImageView = GOPItemView(publisher: rightPublisher)
    
    // MARK: Life Cycle
    init(
        spacing: CGFloat,
        leftPublisher: GOPIVMPublisher,
        centerPublisher: GOPIVMPublisher,
        rightPublisher: GOPIVMPublisher
    ) {
        self.spacing = spacing
        self.leftPublisher = leftPublisher
        self.centerPublisher = centerPublisher
        self.rightPublisher = rightPublisher
        
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
