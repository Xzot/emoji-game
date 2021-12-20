//
//  EmojiModel.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 19.12.2021.
//

import Foundation

struct EmojiModel: Decodable {
    let id: Int
    let name: String
    let unicode: String
    let imageName: String
}
