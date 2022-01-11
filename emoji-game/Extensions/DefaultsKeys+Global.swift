//
//  DefaultsKeys+Global.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 19.12.2021.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    var usedHypo: DefaultsKey<[String : Bool]> {
        .init("EmojiGame.DefaultsKeys.usedEmojiHypo", defaultValue: [:])
    }
    
    var scoreRecordValue: DefaultsKey<Int> {
        .init("EmojiGame.DefaultsKeys.scoreRecordValue", defaultValue: 0)
    }
}
