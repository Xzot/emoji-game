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
    private var cancellable = Set<AnyCancellable>()
    @ThreadSafe(
        wrappedValue: nil,
        queue: DispatchQueue.global(qos: .userInitiated)
    ) private var latestUsedScore: GameTimeModel?
    private var animationId = ""
    
    // MARK: UI
    private lazy var timerImage = UIImageView(image: Asset.Images.gameTimer.image)
    private lazy var timeLabel = UILabel()&>.do {
        $0.font = .quicksand(
            ofSize: max(28, 32 * UIDevice.sizeFactor),
            weight: .bold
        )
        $0.textColor = Asset.Palette.black.color
        $0.textAlignment = .left
    }
    private lazy var addedTimeLabel = UILabel()&>.do {
        $0.font = .quicksand(
            ofSize: max(28, 32 * UIDevice.sizeFactor),
            weight: .bold
        )
    }
    
    // MARK: Life Cycle
    init(_ timePublisher: GameTimePublisher) {
        super.init(frame: .zero)
        
        addSubview(timerImage)
        timerImage.centerYToSuperview()
        timerImage.leftToSuperview()
        timerImage.size(CGSize(width: 24, height: 24))
        
        addSubview(timeLabel)
        timeLabel.verticalToSuperview()
        timeLabel.leftToRight(of: timerImage, offset: 8)
        
        addSubview(addedTimeLabel)
        addedTimeLabel.verticalToSuperview()
        addedTimeLabel.leftToRight(of: timeLabel, offset: 8)
        addedTimeLabel.rightToSuperview(relation: .equalOrLess)
        
        timePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] time in
                self?.handle(new: time)
            }
            .store(in: &cancellable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GameTimerLabel {
    func handle(new score: GameTimeModel?) {
        _latestUsedScore.mutate { $0 = score }
        
        guard let score = score else {
            timeLabel.text = "0"
            return
        }
        timeLabel.text = String(score.new)
        setAddedScoreLabel(score.new - (score.old ?? 0))
    }
    
    func setAddedScoreLabel(_ diff: Int) {
        guard diff != -1, diff < 5 else {
            return
        }
        let aId = UUID().uuidString + ":" + String(Date().timeIntervalSince1970)
        animationId = aId
        var scoreText = ""
        if diff > 0 {
            addedTimeLabel.textColor = Asset.Palette.jungleGreen.color
            scoreText = "+" + String(diff)
        } else if diff < 0 {
            addedTimeLabel.textColor = Asset.Palette.burntSienna.color
            scoreText = String(diff)
        }
        addedTimeLabel.scoreUpdateAnimated(text: scoreText) { [weak self] in
            guard
                let self = self,
                self.animationId == aId
            else { return }
            UIView.animateKeyframes(
                withDuration: AppConstants.Animation.shortDuration,
                delay: AppConstants.Animation.shortDelay
            ) { [weak self] in
                self?.addedTimeLabel.alpha = 0
            } completion: { _ in }
        }
    }
}
