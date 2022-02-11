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
    @ThreadSafe(
        wrappedValue: nil,
        queue: DispatchQueue.global(qos: .userInitiated)
    ) private var latestUsedScore: GameScoreModel?
    private var cancellable = Set<AnyCancellable>()
    private var animationId = ""
    
    // MARK: UI
    private lazy var startView = UIImageView(image: Asset.Images.gameScoreStar.image)
    private lazy var scoreLabel = UILabel()&>.do {
        $0.font = .quicksand(
            ofSize: max(28, 32 * UIDevice.sizeFactor),
            weight: .bold
        )
        $0.textColor = Asset.Palette.black.color
    }
    private lazy var addedScoreLabel = UILabel()&>.do {
        $0.font = .quicksand(
            ofSize: max(28, 32 * UIDevice.sizeFactor),
            weight: .bold
        )
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
        
        addSubview(addedScoreLabel)
        addedScoreLabel.verticalToSuperview()
        addedScoreLabel.leftToRight(of: scoreLabel, offset: 8)
        addedScoreLabel.width(60)
        
        score
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] model in
                self?.handle(new: model)
            })
            .store(in: &cancellable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension GameScoreLabel {
    func handle(new score: GameScoreModel?) {
        _latestUsedScore.mutate { $0 = score }
        
        guard let score = score else {
            scoreLabel.text = "0"
            return
        }
        scoreLabel.text = String(score.new)
        setAddedScoreLabel(score.new - (score.old ?? 0))
    }
    
    func setAddedScoreLabel(_ diff: Int) {
        let aId = UUID().uuidString + ":" + String(Date().timeIntervalSince1970)
        animationId = aId
        var scoreText = ""
        if diff > 0 {
            addedScoreLabel.textColor = Asset.Palette.jungleGreen.color
            scoreText = "+" + String(diff)
        } else if diff < 0 {
            addedScoreLabel.textColor = Asset.Palette.burntSienna.color
            scoreText = String(diff)
        }
        addedScoreLabel.scoreUpdateAnimated(text: scoreText) { [weak self] in
            guard
                let self = self,
                    self.animationId == aId
            else { return }
            UIView.animateKeyframes(
                withDuration: AppConstants.Animation.shortDuration,
                delay: AppConstants.Animation.shortDelay
            ) { [weak self] in
                self?.addedScoreLabel.alpha = 0
            } completion: { _ in }
        }
    }
}
