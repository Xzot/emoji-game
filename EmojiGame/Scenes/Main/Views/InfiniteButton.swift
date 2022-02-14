//
//  InfiniteButton.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 14.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - InfiniteButton class
final class InfiniteButton: UIView, SelectableTransform {
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
        $0.textColor = Asset.Palette.white.color
        $0.text = Strings.MainScene.infiniteButtonName
        $0.font = .quicksand(
            ofSize: max(28, 32 * UIDevice.sizeFactor),
            weight: .bold
        )
        $0.textAlignment = .left
    }
    private lazy var imageView = UIImageView()&>.do {
        $0.image = Asset.Images.startInfinite.image
        $0.clipsToBounds = true
    }
    
    // MARK: Life Cycle
    init(completion: @escaping VoidCompletion) {
        self.completion = completion
        
        super.init(frame: .zero)
        
        backgroundColor = Asset.Palette.jungleGreen.color
        
        addSubview(imageView)
        let imageViewSize = max(32, 32 * UIDevice.sizeFactor)
        imageView.size(
            CGSize(width: imageViewSize, height: imageViewSize)
        )
        imageView.centerYToSuperview()
        imageView.leftToSuperview(offset: max(74, 74 * UIDevice.sizeFactor))
        
        addSubview(titleLable)
        titleLable.centerYToSuperview()
        titleLable.rightToSuperview()
        titleLable.leftToRight(of: imageView, offset: max(16, 16 * UIDevice.sizeFactor))
        
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
private extension InfiniteButton {
    @objc
    func handleButtonTap() {
        completion()
    }
}
