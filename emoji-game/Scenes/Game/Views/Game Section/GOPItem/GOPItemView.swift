//
//  GOPItemView.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 07.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - GOPItemView class
final class GOPItemView: UIView {
    // MARK: UI
    private lazy var imageView = ImageView(
        image: imageState.eraseToAnyPublisher(),
        type: .embded
    )&>.do {
        $0.layer.borderWidth = 4
        $0.layer.cornerRadius = 24
        $0.layer.borderColor = Asset.Palette.gallery.color.cgColor
    }
    private lazy var button = UIButton()&>.do {
        $0.publisher(for: \.isSelected)
            .sink(receiveValue: setIsSelected(_:))
            .store(in: &cancellable)
        $0.publisher(for: \.isHighlighted)
            .sink(receiveValue: setIsHiglighted(_:))
            .store(in: &cancellable)
        $0.addTarget(
            self,
            action: #selector(handleTap),
            for: .touchUpInside
        )
    }
    
    // MARK: Properties
    private var viewModel: GOPItemModel? {
        didSet {
            imageState.send(viewModel?.image)
        }
    }
    private var imageState = ImageState(nil)
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    init(publisher: GOPIVMPublisher) {
        super.init(frame: .zero)
        
        addSubview(imageView)
        imageView.edgesToSuperview()
        
        addSubview(button)
        button.edgesToSuperview()
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handle(viewModel:))
            .store(in: &cancellable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - GOPItemView private
private extension GOPItemView {
    @objc
    func handleTap() {
        guard
            let viewModel = viewModel,
            button.isSelected == false else { return }
        button.isSelected = true
        // Выглядит странно, нужно будет подправить :)
        viewModel.tryUseCompletion(viewModel)
    }
    
    func handle(viewModel: GOPItemModel?) {
        button.isSelected = false
        self.viewModel = viewModel
    }
    
    func setIsHiglighted(_ value: Bool) {
        if value == true {
            let maxTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            transform = maxTransform
        } else {
            let minTransform = CGAffineTransform(scaleX: 1, y: 1)
            transform = minTransform
        }
    }
    
    func setIsSelected(_ value: Bool) {
        if value == true {
            imageView.layer.borderColor = viewModel?.isCorrect == true ? Asset.Palette.jungleGreen.color.cgColor : Asset.Palette.burntSienna.color.cgColor
        } else {
            imageView.layer.borderColor = Asset.Palette.gallery.color.cgColor
        }
    }
}
