//
//  AppConstants.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit

enum AppConstants {
    static let startGameTime = 10
    static let startGameScore = 0
    static let adsPurchaseProductId = "com.rnh.emojiMix.freeFromAds"
    static let adUnitId = "ca-app-pub-4674777145864617/9890688531"
    static let deselectGameItemNotificationName = NSNotification.Name(
        "AppConstants.deselctGameItemNotificationName"
    )
}

extension AppConstants {
    struct MainScene {
        static let gifMultiplier: CGFloat = 0.34
        static let playButtonSize: CGFloat = max(160, 196 * UIDevice.sizeFactor)
    }
}

extension AppConstants {
    struct Animation {
        static let shortDelay: CGFloat = 0.4
        static let delay: CGFloat = 0.8
        static let shortDuration: CGFloat = 0.1
        static let longDuration: CGFloat = 0.2
        static let lightExpand: CGFloat = 1.1
        static let expand: CGFloat = 1.2
        static let bigExpand: CGFloat = 1.4
        static let decrease: CGFloat = 0.8
    }
}
