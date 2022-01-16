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
    private lazy var playButton = PlayButton(
        score: viewModel.scoreOutut,
        completion: { [weak self] in
            self?.viewModel.playTapped()
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
        
        addSubview(playButton)
        
        let playButtonSize = AppConstants.MainScene.playButtonSize
        playButton.size(
            CGSize(
                width: playButtonSize,
                height: playButtonSize
            )
        )
        playButton.centerXToSuperview()
        playButton.topToSuperview(offset: max(30, 40 * UIDevice.sizeFactor))
        
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
        viewModel.isSoundsHiddenOutput
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.soundButton.isSelected = value == false
            }
            .store(in: &cancellable)
    }
}
