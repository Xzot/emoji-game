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
    
    // MARK: UI
    private lazy var startView = UIImageView(image: Asset.Images.gameScoreStar.image)
    private lazy var scoreLabel = UILabel()&>.do {
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
        // Thead safe call for reference value
        _latestUsedScore.mutate { $0 = score }
        
        guard let score = score else {
            scoreLabel.text = "0"
            return
        }
        #warning("TODO: Нужно или убрать текущий фейд или доделать")
//        scoreLabel.fadeTransition(2.25)
        if let old = score.old {
            scoreLabel.attributedText = attributedText(score.new, score.new - old)
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 1,
                execute: DispatchWorkItem { [weak self] in
                    guard self?._latestUsedScore.wrappedValue == score else {
                        return
                    }
                    self?.handle(new: score.makeWithoutOld())
                }
            )
        } else {
            scoreLabel.attributedText = attributedText(score.new)
        }
    }
    
    func attributedText(_ left: Int, _ right: Int? = nil) -> NSMutableAttributedString {
        let text = right ?? 0 == 0 ?
        String(left) :
        String(left) + " " + (
            right ?? 0 > 0 ? "+" + String(right ?? 0) : String(right ?? 0)
        )
        let string = NSMutableAttributedString(string: text)
        
        string.setColorForText(
            String(left),
            with: Asset.Palette.black.color
        )
        
        guard
            right ?? 0 != 0,
            let right = right
        else {
            return string
        }
        
        string.setColorForText(
            String(right),
            with: right > 0 ? Asset.Palette.jungleGreen.color : Asset.Palette.burntSienna.color
        )
        
        guard right > 0 else {
            return string
        }
        
        string.setColorForText(
            "+",
            with: Asset.Palette.jungleGreen.color
        )
        
        return string
    }
}
