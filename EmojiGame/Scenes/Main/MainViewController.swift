//
//  Created by Vlad Shchuka on 20.12.2021.
//

import Gifu
import UIKit
import Combine
import TinyConstraints

// MARK: - Consts
extension MainViewController {
    struct UiConsts {
        let gifImageViewMultiplier: CGFloat = 0.34
        let timeAttackButtonMultiplier: CGFloat = 0.108
        let infiniteButtonMultiplier: CGFloat = 0.078
        let roundedButtonsMultiplier: CGFloat = 0.088
        let defaultSpacingValue = max(12, 16 * UIDevice.sizeFactor)
        let mediumSpacingValue = max(26, 32 * UIDevice.sizeFactor)
        let bigSpacingValue = max(30, 42 * UIDevice.sizeFactor)
        let roundedButtonsSpacingSizeValue = max(18, 24 * UIDevice.sizeFactor)
    }
}

// MARK: - MainViewController class
final class MainViewController: SwapChildViewController {
    // MARK: Properties
    private let viewModel: MainViewModel
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: UI
    private lazy var imageView = GIFImageView(
        image: Asset.Images.startHeader.image
    )&>.do {
        $0.contentMode = .scaleAspectFit
    }
    private lazy var label = UILabel()&>.do {
        $0.textColor = Asset.Palette.black.color
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.text = Strings.MainScene.labelText
        $0.font = .quicksand(
            ofSize: max(48, 56 * UIDevice.sizeFactor),
            weight: .bold
        )
    }
    private lazy var timeAttackButton = TimeAttackButton(
        score: viewModel.scoreOutut
    ) { [weak self] in
        self?.viewModel.timeAttackPlayTapped()
    }
    private lazy var infiniteButton = InfiniteButton { [weak self] in
        self?.viewModel.infinitePlayTapped()
    }
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
    private lazy var restoreButton = UIButton()&>.do {
        $0.titleLabel?.font = .quicksand(
            ofSize: 17,
            weight: .bold
        )
        $0.setTitleColor(
            Asset.Palette.gullGray.color,
            for: .normal
        )
        $0.setTitle(
            Strings.MainScene.restorePurchaseButtonScoreTitle,
            for: .normal
        )
        $0.addTarget(
            self,
            action: #selector(handleRestoreButtonTap),
            for: .touchUpInside
        )
    }
    private lazy var cheatButton = UIButton()&>.do {
        $0.addTarget(
            self,
            action: #selector(handleCheatButtonTap),
            for: .touchUpInside
        )
    }
    
    // MARK: Life Cycle
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let consts = UiConsts()
        
        view.backgroundColor = Asset.Palette.white.color
        
        view.addSubview(imageView)
        imageView.topToSuperview(usingSafeArea: true)
        imageView.horizontalToSuperview()
        imageView.height(
            to: view,
            multiplier: consts.gifImageViewMultiplier
        )
        
        view.addSubview(label)
        label.topToBottom(of: imageView)
        label.centerXToSuperview()
        label.horizontalToSuperview(
            relation: .equalOrGreater,
            usingSafeArea: true
        )
        
        view.addSubview(adsButton)
        adsButton.widthToHeight(of: adsButton)
        adsButton.height(
            to: view,
            multiplier: consts.roundedButtonsMultiplier
        )
        adsButton.leftToSuperview(
            offset: consts.roundedButtonsSpacingSizeValue,
            usingSafeArea: true
        )
        adsButton.bottomToSuperview(
            offset: -consts.defaultSpacingValue,
            usingSafeArea: true
        )
        
        view.addSubview(soundButton)
        soundButton.widthToHeight(of: soundButton)
        soundButton.height(
            to: view,
            multiplier: consts.roundedButtonsMultiplier
        )
        soundButton.rightToSuperview(
            offset: -consts.roundedButtonsSpacingSizeValue,
            usingSafeArea: true
        )
        soundButton.bottomToSuperview(
            offset: -consts.defaultSpacingValue,
            usingSafeArea: true
        )
        
        view.addSubview(infiniteButton)
        infiniteButton.horizontalToSuperview(
            insets: .left(consts.mediumSpacingValue) + .right(consts.mediumSpacingValue),
            usingSafeArea: true
        )
        infiniteButton.height(
            to: view,
            multiplier: consts.infiniteButtonMultiplier
        )
        infiniteButton.bottomToTop(
            of: soundButton,
            offset: -consts.bigSpacingValue
        )
        
        view.addSubview(timeAttackButton)
        timeAttackButton.horizontalToSuperview(
            insets: .left(consts.mediumSpacingValue) + .right(consts.mediumSpacingValue),
            usingSafeArea: true
        )
        timeAttackButton.height(
            to: view,
            multiplier: consts.timeAttackButtonMultiplier
        )
        timeAttackButton.bottomToTop(
            of: infiniteButton,
            offset: -consts.defaultSpacingValue
        )
        
        view.addSubview(restoreButton)
        restoreButton.size(CGSize(width: 160, height: 40))
        restoreButton.topToSuperview(usingSafeArea: true)
        restoreButton.leftToSuperview(offset: 16, usingSafeArea: true)
        
        view.addSubview(cheatButton)
        cheatButton.size(CGSize(width: 160, height: 40))
        cheatButton.topToSuperview(usingSafeArea: true)
        cheatButton.rightToSuperview(offset: -16, usingSafeArea: true)
        
        imageView.prepareForAnimation(
            withGIFNamed: "main_emojis",
            completionHandler: nil
        )
        
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.startAnimatingGIF()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imageView.stopAnimatingGIF()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

// MARK: - Private
private extension MainViewController {
    @objc
    func handleRestoreButtonTap() {
        viewModel.restoreNoAdsTapped()
    }
    
    @objc
    func handleCheatButtonTap() {
        viewModel.cheatTapped()
    }
    
    func bind() {
        viewModel.isAdsHiddenOutput
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.adsButton.isHidden = value
                self?.restoreButton.isHidden = value
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
