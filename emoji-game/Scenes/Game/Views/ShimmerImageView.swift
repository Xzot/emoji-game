//
//  ShimmerImageView.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit
import Combine
import SkeletonView
import TinyConstraints

// MARK: - ShimmerImageView class
final class ShimmerImageView: UIView {
    // MARK: Properties
    private var content: UIImage?
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: UI
    private lazy var skeletonView = UIView()&>.do {
        $0.isSkeletonable = true
    }
    private lazy var imageView = UIImageView()&>.do {
        $0.contentMode = .scaleAspectFill
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
    init(image: ImagePublisher) {
        super.init(frame: .zero)
        
        addSubview(imageView)
        imageView.edgesToSuperview()
        
        addSubview(skeletonView)
        skeletonView.edgesToSuperview()
        
        image
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handle(_:))
            .store(in: &cancellable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ShimmerImageView extension
private extension ShimmerImageView {
    func handle(_ image: UIImage?) {
        content = image
        imageView.image = image == nil ? Asset.Images.gamePlaceholder.image : image
        if image == nil {
            skeletonView.showSkeleton()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard self?.content == nil else {
                    return
                }
                self?.skeletonView.startSkeletonAnimation()
            }
        } else {
            skeletonView.hideSkeleton(transition: .none)
        }
    }
}
