//
//  DataLoader.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 03.01.2022.
//

import Foundation

// MARK: - DataLoaderError
enum DataLoaderError: Error {
    case failedToLoad
}

// MARK: - DataLoader class
final class DataLoader {
    // MARK: Properties
    private let config: Config
    private lazy var pendingOperations = PendingOperations(config)
    
    // MARK: Life Cycle
    init(config: Config) {
        self.config = config
    }
    
    // MARK: Public API
    func fetchData(
        at link: String,
        completion: @escaping (Result<Data, DataLoaderError>) -> Void
    ) {
        let loadOperation = LoadDataOperation(link)
        loadOperation.completionBlock = {
            switch loadOperation.state {
            case .finished(let fetchedData):
                completion(.success(fetchedData))
            default:
                completion(.failure(.failedToLoad))
            }
        }
        pendingOperations.append(loadOperation)
    }
}

// MARK: - DataLoader Config
extension DataLoader {
    struct Config {
        let queName: String
        let maxConcurrentOperationCount: Int
    }
}

// MARK: - PendingOperations class
fileprivate final class PendingOperations {
    // MARK: Properties
    private let lock = NSLock()
    private let config: DataLoader.Config
    private lazy var downloadsInProgress = [String : Operation]()
    private lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = config.queName
        queue.maxConcurrentOperationCount = config.maxConcurrentOperationCount
        return queue
    }()
    
    // MARK: Life Cycle
    init(_ config: DataLoader.Config) {
        self.config = config
    }
    
    // MARK: Public API
    func append(_ operation: LoadDataOperation) {
        lock.lock()
        guard downloadsInProgress[operation.linkToData] == nil else {
            lock.unlock()
            return
        }
        downloadsInProgress[operation.linkToData] = operation
        downloadQueue.addOperation(operation)
        lock.unlock()
    }
}

// MARK: - LoadDataOperation class
fileprivate class LoadDataOperation: Operation {
    // MARK: Properties
    let linkToData: String
    private(set) var state: ActionState = .pending
    
    // MARK: Life Cycle
    init(_ linkToData: String) {
        self.linkToData = linkToData
    }
    
    override func main() {
        state = .inProgress
        if isCancelled {
            return
        }
        guard let url = URL(string: linkToData) else {
            state = .failed
            return
        }
        guard let imageData = try? Data(contentsOf: url) else {
            state = .failed
            return
        }
        if isCancelled {
            return
        }
        if imageData.count > 0 {
            state = .finished(imageData)
        } else {
            state = .failed
        }
    }
}

// MARK: - ActionState enum
fileprivate extension LoadDataOperation {
    enum ActionState {
      case finished(Data), failed, inProgress, pending
    }
}
