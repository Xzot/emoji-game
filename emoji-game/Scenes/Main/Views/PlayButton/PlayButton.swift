//
//  PlayButton.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit
import Combine
import TinyConstraints

// MARK: - PlayButton class
final class PlayButton: CustomButton {
    // MARK: UI
    private lazy var absorbingView = PBAbsorbingView(scorePublisher)
    
    // MARK: Properties
    private let scorePublisher: AnyPublisher<Int, Never>
    
    // MARK: Life Cycle
    init(
        score: AnyPublisher<Int, Never>,
        completion: @escaping VoidCompletion
    ) {
        self.scorePublisher = score
        
        super.init(completion: completion)
        
        backgroundColor = Asset.Palette.jungleGreen.color
        
        addSubview(absorbingView)
        absorbingView.centerInSuperview()
        absorbingView.horizontalToSuperview(usingSafeArea: true)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
