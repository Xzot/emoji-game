//
//  GOPItemView.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 07.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - API
extension GOPItemView {
    func animateClueAsCorrect() {
        guard viewModel?.isCorrect == true else {
            return
        }
        imageView.layer.borderColor = Asset.Palette.jungleGreen.color.cgColor
        imageView.expandAnimated(
            with: AppConstants.Animation.longDuration,
            closure: { [weak self] in
                self?.imageView.backToNormalAnimated { [weak self] in
                    self?.imageView.expandAnimated(
                        with: AppConstants.Animation.longDuration,
                        closure: { [weak self] in
                            self?.imageView.backToNormalAnimated { [weak self] in
                                self?.imageView.layer.borderColor = Asset.Palette.gallery.color.cgColor
                            }
                        }
                    )
                }
            }
        )
    }
}

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
            .sink(receiveValue: { [weak self] value in
                self?.setIsSelected(value)
            })
            .store(in: &cancellable)
        $0.publisher(for: \.isHighlighted)
            .sink(receiveValue: { [weak self] value in
                self?.setIsHiglighted(value)
            })
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
            .sink(receiveValue: { [weak self] model in
                self?.handle(viewModel: model)
            })
            .store(in: &cancellable)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deselectItem),
            name: AppConstants.deselectGameItemNotificationName,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    @objc
    func deselectItem() {
        button.isSelected = false
    }
    
    func handle(viewModel: GOPItemModel?) {
        button.isSelected = false
        self.viewModel = viewModel
    }
    
    func setIsHiglighted(_ value: Bool) {
        //        if value == true {
        //            let maxTransform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        //            transform = maxTransform
        //        } else {
        //            let minTransform = CGAffineTransform(scaleX: 1, y: 1)
        //            transform = minTransform
        //        }
    }
    
    func setIsSelected(_ value: Bool) {
        guard value == true else {
            imageView.layer.borderColor = Asset.Palette.gallery.color.cgColor
            return
        }
        
        if viewModel?.isCorrect == true {
            imageView.layer.borderColor = Asset.Palette.jungleGreen.color.cgColor
            imageView.expandAnimated { [weak self] in
                self?.imageView.backToNormalAnimated {
                    //nothing
                }
            }
        } else {
            imageView.layer.borderColor = Asset.Palette.burntSienna.color.cgColor
            imageView.decreaseAnimated { [weak self] in
                self?.imageView.backToNormalAnimated {
                    //nothing
                }
            }
        }
    }
}
