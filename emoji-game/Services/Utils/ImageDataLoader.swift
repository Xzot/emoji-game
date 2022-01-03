//
//  ImageDataLoader.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 03.01.2022.
//

import Foundation
import Combine

// MARK: - ImageDataLoader class
final class ImageDataLoader {
    private let loaderConfig = DataLoader.Config(
        queName: "ImageLoader.Download.Queue",
        maxConcurrentOperationCount: 3
    )
    private lazy var dataLoader = DataLoader(config: loaderConfig)
    
    func loadImage(
        at link: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        dataLoader.fetchData(at: link) { result in
            switch result {
            case .success(let loadedData):
                completion(.success(loadedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadImagePublisher(_ link: String) -> AnyPublisher<Data?, Never> {
        let publisher = PassthroughSubject<Data?, Never>()
        loadImage(at: link) { result in
            switch result {
            case .success(let loadedData):
                publisher.send(loadedData)
            case .failure(let error):
                print(error)
            }
        }
        return publisher.eraseToAnyPublisher()
    }
}
