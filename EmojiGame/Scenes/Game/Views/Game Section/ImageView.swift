//
//  ImageView.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - ImageViewType enum
enum ImageViewType {
    case embded
    case def
}

// MARK: - ImageView class
final class ImageView: UIView {
    // MARK: Properties
    private let type: ImageViewType
    private var content: UIImage?
    private var cancellable = Set<AnyCancellable>()
    private lazy var animator = UIViewPropertyAnimator(duration: 1.0, curve: .easeIn, animations: animation)
    
    // MARK: UI
    private lazy var imageView = UIImageView()&>.do {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    // MARK: Life Cycle
    init(
        image: ImagePublisher,
        type: ImageViewType = .def
    ) {
        self.type = type
        
        super.init(frame: .zero)
        
        addSubview(imageView)
        if type == .def {
            imageView.edgesToSuperview()
        } else {
            imageView.height(to: self, multiplier: 0.538)
            imageView.width(to: self, multiplier: 0.538)
            imageView.centerInSuperview()
        }
        
        image
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] image in
                self?.handle(image)
            })
            .store(in: &cancellable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ImageView extension
private extension ImageView {
    func handle(_ image: UIImage?) {
        content = image
        if image == nil {
            imageView.image = Asset.Images.gamePlaceholder.image
            animator.startAnimation()
        } else {
            animator.stopAnimation(true)
            imageView.image = image
        }
    }
    
    func animation() {
        let minTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        let maxTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        let newTransform = imageView.transform == minTransform ? maxTransform : minTransform
        imageView.transform = newTransform
    }
}
