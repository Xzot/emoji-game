//
//  TimeAttackContentView.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - TimeAttackContentView class
final class TimeAttackContentView: UIView {
    // MARK: UI
    private lazy var imageView = UIImageView()&>.do {
        $0.image = Asset.Images.startTimeAttack.image
        $0.clipsToBounds = true
    }
    private lazy var nameLabel = UILabel()&>.do {
        $0.textColor = Asset.Palette.white.color
        $0.text = Strings.MainScene.timeAttackButtonName
        $0.font = .quicksand(
            ofSize: max(24, 28 * UIDevice.sizeFactor),
            weight: .bold
        )
        $0.textAlignment = .left
    }
    private lazy var bestScoreLabel = UILabel()&>.do {
        $0.textColor = Asset.Palette.white.color.withAlphaComponent(0.72)
        $0.font = .quicksand(
            ofSize: max(18, 20 * UIDevice.sizeFactor),
            weight: .regular
        )
        $0.textAlignment = .left
    }
    
    // MARK: Properties
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    init(_ score: AnyPublisher<Int, Never>) {
        super.init(frame: .zero)
        
        let leftSpacing = UIView()
        let rightSpacing = UIView()
        
        addSubview(leftSpacing)
        addSubview(rightSpacing)
        
        leftSpacing.width(to: rightSpacing)
        leftSpacing.edgesToSuperview(excluding: .right)
        rightSpacing.edgesToSuperview(excluding: .left)
        
        addSubview(imageView)
        let imageViewSize = max(32, 32 * UIDevice.sizeFactor)
        imageView.size(
            CGSize(width: imageViewSize, height: imageViewSize)
        )
        imageView.centerYToSuperview()
        imageView.leftToRight(of: leftSpacing)
        
        addSubview(nameLabel)
        nameLabel.topToSuperview()
        nameLabel.rightToLeft(of: rightSpacing)
        nameLabel.leftToRight(of: imageView, offset: max(16, 16 * UIDevice.sizeFactor))
        
        addSubview(bestScoreLabel)
        bestScoreLabel.bottomToSuperview()
        bestScoreLabel.rightToLeft(of: rightSpacing)
        bestScoreLabel.topToBottom(of: nameLabel)
        bestScoreLabel.leftToRight(of: imageView, offset: max(16, 16 * UIDevice.sizeFactor))
        
        score
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.bestScoreLabel.text = Strings.MainScene.bestScoreButtonScoreTitle + String(value)
            }
            .store(in: &cancellable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
