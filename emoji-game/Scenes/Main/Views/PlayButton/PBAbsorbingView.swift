//
//  PBAbsorbingView.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - PBAbsorbingView class
final class PBAbsorbingView: UIView {
    // MARK: UI
    private lazy var nameLabel = UILabel()&>.do {
        $0.textColor = Asset.Palette.white.color
        $0.text = Strings.MainScene.playButtonName
        $0.font = .quicksand(
            ofSize: max(40, 48 * UIDevice.sizeFactor),
            weight: .bold
        )
        $0.textAlignment = .center
    }
    private lazy var bestScoreLabel = UILabel()&>.do {
        $0.textColor = Asset.Palette.white.color.withAlphaComponent(0.72)
        $0.font = .quicksand(
            ofSize: max(18, 20 * UIDevice.sizeFactor),
            weight: .medium
        )
        $0.textAlignment = .center
    }
    
    // MARK: Properties
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: Life Cycle
    init(_ score: AnyPublisher<Int, Never>) {
        super.init(frame: .zero)
        
        addSubview(nameLabel)
        nameLabel.edgesToSuperview(excluding: .bottom)
        
        addSubview(bestScoreLabel)
        bestScoreLabel.edgesToSuperview(excluding: .top)
        bestScoreLabel.topToBottom(of: nameLabel)
        
        score
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.bestScoreLabel.text = Strings.MainScene.playButtonScoreTitle + String(value)
            }
            .store(in: &cancellable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
