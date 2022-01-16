//
//  GameModelsInUseChecker.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 16.01.2022.
//

import SwiftyUserDefaults

// MARK: - DefaultsChecker fileprivate struct
struct GameModelsInUseChecker {
    static func isValueExist(_ value: String) -> Bool {
        var storedItems = Defaults[\.usedHypo]
        if storedItems[value] != nil {
            return true
        } else {
            storedItems[value] = true
            return false
        }
    }
    
    static func markAsUsed(_ value: String) {
        var storedItems = Defaults[\.usedHypo]
        storedItems[value] = true
        Defaults[\.usedHypo] = storedItems
    }
}
