//
//  DefaultsKeys+Global.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 19.12.2021.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    var usedEmojiIndexes: DefaultsKey<[Int]> {
        .init("EmojiGame.DefaultsKeys.usedEmojiIndexes", defaultValue: [])
    }
    
    var readyToUseEmojiIndexes: DefaultsKey<[Int]> {
        .init("EmojiGame.DefaultsKeys.usedEmojiIndexes", defaultValue: [])
    }
}
