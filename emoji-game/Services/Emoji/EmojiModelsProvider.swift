//
//  EmojiModelsProvider.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 19.12.2021.
//

import Foundation

// MARK: - EmojiModelsProvider realization
final class EmojiModelsProvider {
    // MARK: Properties
    private lazy var cachedModels: [EmojiModel]? = nil
    
    // MARK: API
    func fetchEmojis() -> [EmojiModel] {
        if let models = cachedModels {
            return models
        } else {
            guard let data = fetchJsonData() else {
                return [EmojiModel]()
            }
            do {
                let data = try JSONDecoder().decode(EmojiItemsModel.self, from: data)
                cachedModels = data.emojis
                
                return data.emojis
            } catch {
                return [EmojiModel]()
            }
        }
    }
}

// MARK: - EmojiModelsProvider private API
private extension EmojiModelsProvider {
    func fetchJsonData() -> Data? {
        do {
            guard
                let bundlePath = Bundle.main.path(
                    forResource: "emojis",
                    ofType: "json"
                ),
                let jsonData = try String(
                    contentsOfFile: bundlePath
                ).data(using: .utf8)
            else { return nil }
            
            return jsonData
        } catch {            
            return nil
        }
    }
}
