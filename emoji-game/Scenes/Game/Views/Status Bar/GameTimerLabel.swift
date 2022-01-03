//
//  GameTimerLabel.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 03.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - GameTimerLabel class
final class GameTimerLabel: UIView {
    // MARK: Properties
    
    // MARK: UI
    private lazy var timerImage = UIImageView(image: Asset.Images.gameTimer.image)
    private lazy var label = UILabel()&>.do {
        $0.text = "7"
        $0.font = .quicksand(
            ofSize: max(28, 32 * UIDevice.sizeFactor),
            weight: .bold
        )
        $0.textColor = Asset.Palette.black.color
        $0.textAlignment = .left
    }
    
    // MARK: Life Cycle
    init(_ timeValuePublisher: IntPublisher) {
        super.init(frame: .zero)
        
        addSubview(timerImage)
        timerImage.centerYToSuperview()
        timerImage.leftToSuperview()
        timerImage.size(CGSize(width: 24, height: 24))
        
        addSubview(label)
        label.verticalToSuperview()
        label.leftToRight(of: timerImage, offset: 8)
        label.rightToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
