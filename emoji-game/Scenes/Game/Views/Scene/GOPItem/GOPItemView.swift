//
//  GOPItemView.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 07.01.2022.
//

import UIKit
import Combine

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
    func handle(viewModel: GOPItemModel?) {
        self.viewModel = viewModel
    }
}
