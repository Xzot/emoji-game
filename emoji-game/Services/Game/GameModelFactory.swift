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
        let specs: [GameModel.SpecAsset] = fill(
            specs: modelImages
                .map {
                    GameModel.SpecAsset(
                        truly: true,
                        image: $0.image,
                        unicode: $0.unicode
                    )
                }
                .uniqued()
        )
        
        let trullySpecs = specs
            .filter { $0.truly == true }
            .shuffled()
        
        let wrongSpecs = specs
            .filter { $0.truly == false }
            .shuffled()
        
        let topSpecs = [
            trullySpecs[0],
            wrongSpecs[0],
            wrongSpecs[1]
        ]
            .shuffled()
        
        let bottomSpecs = [
            trullySpecs.count > 1 ? trullySpecs[1] : wrongSpecs[4],
            wrongSpecs[2],
            wrongSpecs[3]
        ]
            .shuffled()
        
        let top = GamePanelItems(topSpecs[0], topSpecs[1], topSpecs[2])
        let bottom = GamePanelItems(bottomSpecs[0], bottomSpecs[1], bottomSpecs[2])
        
        return GameModel(topPanel: top, bottomPanel: bottom, result: resultImage)
    }
}

// MARK: Private
private extension GameModelFactory {
    func fill(specs list: [GameModel.SpecAsset]) -> [GameModel.SpecAsset] {
        var specs = list
        repeat {
            guard
                let item = fetchRandomModel(for: specs),
                let image = UIImage(named: item.imageName)
            else { return list }
            specs.append(
                GameModel.SpecAsset(
                    truly: false,
                    image: image,
                    unicode: item.unicode
                )
            )
        } while specs.count < 6
        
        specs.shuffle()
        
        return specs
    }
    
    func fetchRandomModel(for specs: [GameModel.SpecAsset]) -> EmojiModel? {
        var model: EmojiModel?
        let list = emojisList.fetchEmojis()
        
        repeat {
            let fetchedItem: EmojiModel? = list.count > 0 ? list[Int.random(in: (0..<list.count))] : nil
            if specs.filter({ $0.unicode == fetchedItem?.unicode ?? "" }).count == 0 {
                model = fetchedItem
            }
        } while model == nil
        
        return model
    }
}
