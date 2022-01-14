//
//  AppConstants.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit

enum AppConstants {
    static let startGameScore = 0
    static let adUnitId = "ca-app-pub-4674777145864617/9890688531"
}

extension AppConstants {
    struct MainScene {
        static let gifMultiplier: CGFloat = 0.34
        static let playButtonSize: CGFloat = max(160, 196 * UIDevice.sizeFactor)
    }
}
