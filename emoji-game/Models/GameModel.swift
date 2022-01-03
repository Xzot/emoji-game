//
//  GameModel.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 03.01.2022.
//

import UIKit

typealias GamePanelItems = (left: GameModel.SpecAsset, center: GameModel.SpecAsset, right: GameModel.SpecAsset)

struct GameModel {
    let topPanel: GamePanelItems
    let bottomPanel: GamePanelItems
    let result: UIImage
}

extension GameModel {
    struct SpecAsset {
        let truly: Bool
        let image: UIImage
    }
}
