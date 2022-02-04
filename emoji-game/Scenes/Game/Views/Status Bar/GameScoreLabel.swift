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
    private var pendingDiff: Int?
    private var isInAnimation = false
    
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
            .sink(receiveValue: handle(new:))
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
        guard isInAnimation == false, diff != 0 else {
            pendingDiff = diff
            return
        }
        isInAnimation = true
        var scoreText = ""
        if diff > 0 {
            addedScoreLabel.textColor = Asset.Palette.jungleGreen.color
            scoreText = "+" + String(diff)
        } else if diff < 0 {
            addedScoreLabel.textColor = Asset.Palette.vividTangerine.color
            scoreText = String(diff)
        }
        addedScoreLabel.scoreUpdateAnimated(text: scoreText) { [weak self] in
            guard let pending = self?.pendingDiff, pending > 0 else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                    self?.addedScoreLabel.alpha = 0
                    self?.isInAnimation = false
                }
                return
            }
            self?.isInAnimation = false
            self?.pendingDiff = nil
            self?.setAddedScoreLabel(pending)
        }
    }
}
