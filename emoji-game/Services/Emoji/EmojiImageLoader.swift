//
//  EmojiImageLoader.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 04.01.2022.
//

import UIKit
import Combine

final class EmojiImageLoader {
    private let path: String = "https://www.gstatic.com/android/keyboard/emojikitchen/20201001/"
    private let imageDataLoader: ImageDataLoader
    
    init(imageDataLoader: ImageDataLoader) {
        self.imageDataLoader = imageDataLoader
    }
    
    func loadImage(_ endpoint: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        imageDataLoader.loadImage(at: path + endpoint) { result in
            switch result {
            case .success(let loadedData):
                completion(.success(UIImage(data: loadedData)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadImagePublisher(_ endpoint: String) -> AnyPublisher<UIImage?, Never> {
        let publisher = PassthroughSubject<UIImage?, Never>()
        loadImage(endpoint) { result in
            switch result {
            case .success(let image):
                publisher.send(image)
            case .failure(_):
                publisher.send(nil)
            }
        }
        return publisher.eraseToAnyPublisher()
    }
}
