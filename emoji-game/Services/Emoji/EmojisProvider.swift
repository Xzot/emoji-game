//
//  EmojisProvider.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 19.12.2021.
//

import Foundation

protocol EmojisProvider {
    func fetchEmojis() -> [EmojiModel]?
}
