//
//  JSONEmojisProvider.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 19.12.2021.
//

import Foundation

// MARK: - JSONEmojisProvider class
final class JSONEmojisProvider {
    
}

// MARK: - EmojisProvider realization
extension JSONEmojisProvider: EmojisProvider {
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

// MARK: - JSONEmojisProvider private API
private extension JSONEmojisProvider {
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
