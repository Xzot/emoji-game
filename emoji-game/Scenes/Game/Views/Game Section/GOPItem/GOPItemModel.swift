//
//  GOPItemModel.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 07.01.2022.
//

import UIKit

// MARK: - GOPItemViewModel class
struct GOPItemModel {
    let unicode: String
    let image: UIImage?
    let isCorrect: Bool
    var isUsed: Bool = false
    let tryUseCompletion: (GOPItemModel) -> Void
}

// MARK: Map into asset
extension GOPItemModel {
    init?(
        asset: GameModel.SpecAsset?,
        completion: @escaping (GOPItemModel) -> Void
    ) {
        guard let asset = asset else {
            return nil
        }
        self.image = asset.image
        self.isCorrect = asset.truly
        self.tryUseCompletion = completion
        self.unicode = asset.unicode
    }
}

// MARK: - GOPItemModel
extension GOPItemModel: Equatable {
    static func == (lhs: GOPItemModel, rhs: GOPItemModel) -> Bool {
        lhs.unicode == rhs.unicode
    }
}
