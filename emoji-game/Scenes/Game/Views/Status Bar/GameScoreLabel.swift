//
//  GameScoreLabel.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - GameScoreLabel class
final class GameScoreLabel: UIView {
    // MARK: Properties
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: UI
    private lazy var startView = UIImageView(image: Asset.Images.gameScoreStar.image)
    private lazy var scoreLabel = UILabel()&>.do {
        $0.text = "100"
        $0.font = .quicksand(
            ofSize: max(28, 32 * UIDevice.sizeFactor),
            weight: .bold
        )
        $0.textColor = Asset.Palette.black.color
    }
    private lazy var scoreProcedureLabel = UILabel()&>.do {
        $0.text = "-20"
        $0.font = .quicksand(
            ofSize: max(28, 32 * UIDevice.sizeFactor),
            weight: .bold
        )
        $0.textColor = Asset.Palette.burntSienna.color
    }
    
    // MARK: Life Cycle
    init(_ score: GameScorePublisher) {
        super.init(frame: .zero)
        
        addSubview(startView)
        startView.centerYToSuperview()
        startView.leftToSuperview()
        startView.size(
            CGSize(
                width: 22,
                height: 22
            )
        )
        
        addSubview(scoreLabel)
        scoreLabel.verticalToSuperview()
        scoreLabel.leftToRight(of: startView, offset: 8)
        scoreLabel.width(20, relation: .equalOrGreater)
        
        addSubview(scoreProcedureLabel)
        scoreProcedureLabel.verticalToSuperview()
        scoreProcedureLabel.leftToRight(of: scoreLabel, offset: 4)
        scoreProcedureLabel.width(24, relation: .equalOrGreater)
        
        score
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: handle(_:))
            .store(in: &cancellable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GameScoreLabel {
    func handle(_ score: GameScore?) {
        
    }
}
