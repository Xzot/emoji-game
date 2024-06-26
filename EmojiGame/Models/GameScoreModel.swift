//
//  GameScoreModel.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 03.01.2022.
//

import Foundation

struct GameScoreModel: Equatable {
    let old: Int?
    let new: Int
}

extension GameScoreModel {
    func makeNew(with value: Int) -> GameScoreModel {
        .init(old: new, new: value)
    }
    
    func makeWithoutOld() -> GameScoreModel {
        .init(old: nil, new: new)
    }
}
