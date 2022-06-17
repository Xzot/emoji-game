//
//  GameTimeModel.swift
//  EmojiGame
//
//  Created by Vlad Shchuka on 17.06.2022.
//

import Foundation

struct GameTimeModel: Equatable {
    let old: Int?
    let new: Int
}

extension GameTimeModel {
    func makeNew(with value: Int) -> GameTimeModel {
        .init(old: new, new: value)
    }
    
    func makeWithoutOld() -> GameTimeModel {
        .init(old: nil, new: new)
    }
}
