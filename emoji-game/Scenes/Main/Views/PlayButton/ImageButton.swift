//
//  ImageButton.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit
import TinyConstraints

// MARK: - ImageButtonConfig
struct ImageButtonConfig {
    let selectedImage: UIImage?
    let defaultImage: UIImage?
}

// MARK: - ImageButton
final class ImageButton: CustomButton {
    // MARK: Properties
    var isSelected: Bool = false {
        didSet {
            setImage(for: isSelected)
        }
    }
    private let config: ImageButtonConfig
    
    // MARK: UI
    private lazy var imageView = UIImageView()&>.do {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }

    // MARK: Life Cycle
    init(
        config: ImageButtonConfig,
        completion: @escaping VoidCompletion
    ) {
        self.config = config
        
        super.init(completion: completion)
        
        addSubview(imageView)
        imageView.edgesToSuperview()
        
        setImage(for: isSelected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ImageButton {
    func setImage(for isSelected: Bool) {
        if isSelected {
            imageView.image = config.selectedImage
        } else {
            imageView.image = config.defaultImage
        }
    }
}
