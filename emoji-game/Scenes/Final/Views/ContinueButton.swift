//
//  ContinueButton.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 13.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - ContinueButton class
final class ContinueButton: UIView, SelectableTransform {
    // MARK: Properties
    private var completion: VoidCompletion
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: UI
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
    private lazy var imageView = UIImageView(
        image: Asset.Images.adPlayIcon.image
    )&>.do {
        $0.contentMode = .center
    }
    private lazy var titleLable = UILabel()&>.do {
        $0.textColor = Asset.Palette.white.color
        $0.text = Strings.FinalScene.continueButtonTitle
        $0.font = .quicksand(
            ofSize: max(28, 32 * UIDevice.sizeFactor),
            weight: .bold
        )
        $0.textAlignment = .left
    }
    
    // MARK: Life Cycle
    init(completion: @escaping VoidCompletion) {
        self.completion = completion
        
        super.init(frame: .zero)
        
        backgroundColor = Asset.Palette.jungleGreen.color
        
        addSubview(imageView)
        let imageSize: CGFloat = max(26, 32 * UIDevice.sizeFactor)
        imageView.size(CGSize(width: imageSize, height: imageSize))
        imageView.centerYToSuperview()
        imageView.leftToSuperview(offset: max(40, 58 * UIDevice.sizeFactor))
        
        addSubview(titleLable)
        titleLable.centerYToSuperview()
        titleLable.rightToSuperview(usingSafeArea: true)
        titleLable.leftToRight(of: imageView, offset: max(10, 16 * UIDevice.sizeFactor))
        
        addSubview(button)
        button.edgesToSuperview()
        
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension ContinueButton {
    @objc
    func handleButtonTap() {
        completion()
    }
}
