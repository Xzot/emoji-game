//
//  EmojisProvider.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 19.12.2021.
//

import Foundation

// MARK: - EmojisProvider realization
final class EmojisProvider {
    func fetchEmojis() -> [EmojiModel]? {
        guard let data = fetchJsonData() else {
            return nil
        }
        do {
            let emojisModel = try JSONDecoder().decode(EmojiItemsModel.self, from: data)
            return emojisModel.emojis
        } catch {
            print(error)
            return nil
        }
    }
}

// MARK: - EmojisProvider private API
private extension EmojisProvider {
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
            print(error)
        }
        
        return nil
    }
}
