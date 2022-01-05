//
//  AppConstants.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit

enum AppConstants {
    
}

extension AppConstants {
    struct Defaults {
        let usedHypoKey: String = "EmojiGame.AppConstants.Defaults.usedHypoKey"
    }
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
