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
    let pattern: String
    
    func markAsUsed() {
        GameModelsInUseChecker.markAsUsed(pattern)
    }
}

extension GameModel {
    struct SpecAsset: Hashable {
        let truly: Bool
        let image: UIImage
        let unicode: String
    }
}

extension GameModel {
    func isFullyGuessed(_ models: [GOPItemModel]) -> Bool {
        models.removingDuplicates().count == numberOfTrullyItems
    }
}

private extension GameModel {
    var numberOfTrullyItems: Int {
        var value: Int = 0
        
        if topPanel.left.truly {
            value += 1
        }
        if topPanel.center.truly {
            value += 1
        }
        if topPanel.right.truly {
            value += 1
        }
        
        if bottomPanel.left.truly {
            value += 1
        }
        if bottomPanel.center.truly {
            value += 1
        }
        if bottomPanel.right.truly {
            value += 1
        }
        
        return value
    }
}
