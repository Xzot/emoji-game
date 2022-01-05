//
//  GameModelFactory.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 05.01.2022.
//

import UIKit

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
        and modelImages: UIImage...
    ) -> GameModel? {
        var specs = [GameModel.SpecAsset]()
        specs.append(
            contentsOf: modelImages.map { GameModel.SpecAsset(truly: true, image: $0) }
        )
        repeat {
            let list = emojisList.fetchEmojis()
            let item: EmojiModel? = list.count > 0 ? list[Int.random(in: (0..<list.count))] : nil
            guard
                let item = item,
                let image = UIImage(named: item.imageName)
            else { return nil }
            specs.append(GameModel.SpecAsset.init(truly: false, image: image))
        } while specs.count < 6
        
        specs.shuffle()
        
        let top = GamePanelItems(specs[0], specs[1], specs[2])
        let bottom = GamePanelItems(specs[3], specs[4], specs[5])
        
        return GameModel(topPanel: top, bottomPanel: bottom, result: resultImage)
    }
}
