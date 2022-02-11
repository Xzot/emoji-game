//
//  Queue.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 03.01.2022.
//

import Foundation
import Combine

// MARK: - Combine
extension Queue {
    // MARK: Output
    var listCount: AnyPublisher<Int, Never> {
        listCountState.eraseToAnyPublisher()
    }
}

// MARK: - Queue
final class Queue<T> {
    // MARK: Properties
    var list = [T]() {
        didSet {
            listCountState.send(list.count)
        }
    }
    private lazy var listCountState = CurrentValueSubject<Int, Never>(list.count)
    
    // MARK: API
    func enqueue(_ element: T) {
        list.append(element)
    }
    
    func dequeue() -> T? {
        if !list.isEmpty {
            return list.removeFirst()
        } else {
            return nil
        }
    }
    
    func peek() -> T? {
        if !list.isEmpty {
            return list[0]
        } else {
            return nil
        }
    }
}
