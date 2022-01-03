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
    
    // MARK: UI
    private lazy var imageView = UIImageView()&>.do {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    // MARK: API
    func update(_ image: ImagePublisher) {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        
        image
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handle(_:))
            .store(in: &cancellable)
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
            .sink(receiveValue: handle(_:))
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
        imageView.image = image == nil ? Asset.Images.gamePlaceholder.image : image
    }
}
