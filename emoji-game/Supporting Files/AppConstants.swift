//
//  AppConstants.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit
import Combine

typealias VoidCompletion = () -> Void
typealias ImagePublisher = AnyPublisher<UIImage?, Never>

enum AppConstants {
    
}

extension AppConstants {
    struct MainScene {
        
    }
}

extension AppConstants.MainScene {
    struct PulseAnimation {
        let duration: CGFloat = 1
        let delay: CGFloat = 0
        let minScale: CGFloat = 0.95
        let maxScale: CGFloat = 1.0
    }
}
