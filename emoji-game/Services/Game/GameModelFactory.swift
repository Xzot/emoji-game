//
//  GameModelFactory.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 05.01.2022.
//

import UIKit

// MARK: - GameModelFactory's Item
extension GameModelFactory {
    struct Item {
        let image: UIImage
        let unicode: String
    }
}

// MARK: - GameModelFactory class
final class GameModelFactory {
    // MARK: Properties
    let emojisList: EmojiModelsProvider
    
    // MARK: Life Cycle
    init(emojisList: EmojiModelsProvider) {
        self.emojisList = emojisList
    }
    
    // MARK: API
    func assembly(
        from resultImage: UIImage,
        and modelImages: [GameModelFactory.Item]
    ) -> GameModel? {
        var specs: [GameModel.SpecAsset] = modelImages
            .map {
                GameModel.SpecAsset(
                    truly: true,
                    image: $0.image,
                    unicode: $0.unicode
                )
            }
            .uniqued()
        
        repeat {
            let list = emojisList.fetchEmojis()
            let item: EmojiModel? = list.count > 0 ? list[Int.random(in: (0..<list.count))] : nil
            guard
                let item = item,
                let image = UIImage(named: item.imageName)
            else { return nil }
            specs.append(
                GameModel.SpecAsset(
                    truly: false,
                    image: image,
                    unicode: item.unicode
                )
            )
            specs = specs.uniqued()
        } while specs.count < 6
        
        specs.shuffle()
        
        let top = GamePanelItems(specs[0], specs[1], specs[2])
        let bottom = GamePanelItems(specs[3], specs[4], specs[5])
        
        return GameModel(topPanel: top, bottomPanel: bottom, result: resultImage)
    }
}
