//
//  PlaySceneBar.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - PlaySceneBar class
final class PlaySceneBar: UIView {
    // MARK: UI
    private lazy var stackView = UIStackView()&>.do {
        $0.spacing = 16
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    private lazy var timeAttackButton = InfiniteButton(
        title: "TIME ATTACK",
        completion: { [weak self] in
            self?.viewModel.timeAttackPlayTapped()
        }
    )
    private lazy var infiniteButton = InfiniteButton(
        title: "INFINITE",
        completion: { [weak self] in
            self?.viewModel.infinitePlayTapped()
        }
    )
    private lazy var adsButton = ImageButton(
        config: ImageButtonConfig(
            selectedImage: Asset.Images.startNoAds.image,
            defaultImage: Asset.Images.startNoAds.image
        ),
        completion: { [weak self] in
            self?.viewModel.adsTapped()
        }
    )
    private lazy var soundButton = ImageButton(
        config: ImageButtonConfig(
            selectedImage: Asset.Images.startSoundOff.image,
            defaultImage: Asset.Images.startSoundOn.image
        ),
        completion: { [weak self] in
            self?.viewModel.soundTapped()
        }
    )
    
    // MARK: Properties
    private let viewModel: MainViewModel
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        addSubview(stackView)
        stackView.horizontalToSuperview(
            insets: .left(max(16, 24 * UIDevice.sizeFactor)) + .right(max(16, 24 * UIDevice.sizeFactor))
        )
        stackView.topToSuperview(offset: max(30, 40 * UIDevice.sizeFactor))
        stackView.height(to: self, multiplier: 0.4)
        
        stackView.addArrangedSubview(timeAttackButton)
        stackView.addArrangedSubview(infiniteButton)
                
        let smallButtonsSize: CGFloat = max(60, 72 * UIDevice.sizeFactor)
        let smallButtonBottomOffset: CGFloat = max(10, 16 * UIDevice.sizeFactor)
        let smallButtonSideOffset: CGFloat = max(18, 24 * UIDevice.sizeFactor)
        
        addSubview(adsButton)
        adsButton.bottomToSuperview(
            offset: -smallButtonBottomOffset,
            usingSafeArea: true
        )
        adsButton.leftToSuperview(offset: smallButtonSideOffset)
        adsButton.size(
            CGSize(
                width: smallButtonsSize,
                height: smallButtonsSize
            )
        )
        
        addSubview(soundButton)
        soundButton.bottomToSuperview(
            offset: -smallButtonBottomOffset,
            usingSafeArea: true
        )
        soundButton.rightToSuperview(offset: -smallButtonSideOffset)
        soundButton.size(
            CGSize(
                width: smallButtonsSize,
                height: smallButtonsSize
            )
        )
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension PlaySceneBar {
    func bind() {
        viewModel.isAdsHiddenOutput
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.adsButton.isHidden = value
            }
            .store(in: &cancellable)
        
        viewModel.isSoundsHiddenOutput
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.soundButton.isSelected = value == false
            }
            .store(in: &cancellable)
    }
}
