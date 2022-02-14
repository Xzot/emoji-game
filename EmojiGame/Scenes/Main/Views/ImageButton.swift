//
//  ImageButton.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - ImageButtonConfig
struct ImageButtonConfig {
    let selectedImage: UIImage?
    let defaultImage: UIImage?
}

extension ImageButtonConfig {
    init(_ image: UIImage?) {
        selectedImage = image
        defaultImage = image
    }
}

// MARK: - ImageButton
final class ImageButton: UIView, SelectableTransform {
    // MARK: Properties
    var isSelected: Bool = false {
        didSet {
            setImage(for: isSelected)
        }
    }
    private let config: ImageButtonConfig
    private let completion: VoidCompletion
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: UI
    private lazy var imageView = UIImageView()&>.do {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
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

    // MARK: Life Cycle
    init(
        config: ImageButtonConfig,
        completion: @escaping VoidCompletion
    ) {
        self.config = config
        self.completion = completion
        
        super.init(frame: .zero)
        
        addSubview(imageView)
        imageView.edgesToSuperview()
        
        addSubview(button)
        button.edgesToSuperview()
        
        setImage(for: isSelected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension ImageButton {
    func setImage(for isSelected: Bool) {
        if isSelected {
            imageView.image = config.selectedImage
        } else {
            imageView.image = config.defaultImage
        }
    }
    
    @objc
    func handleButtonTap() {
        completion()
    }
}
