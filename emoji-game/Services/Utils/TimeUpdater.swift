//
//  TimeUpdater.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 07.01.2022.
//

import Foundation
import Combine

// MARK: - TimeUpdater class
final class TimeUpdater {
    // MARK: Output
    var completion: AnyPublisher<Void, Never> {
        completionSubject.eraseToAnyPublisher()
    }
    
    // MARK: Properties
    private let completionSubject = PassthroughSubject<Void, Never>()
    private var timer: Timer!
    
    // MARK: Life Cycle
    init() {
        self.makeTimer()
    }
    
    deinit {
        invalidate()
    }
    
    // MARK: API
    func restart() {
        if timer.isValid == true {
            timer.invalidate()
        }
        makeTimer()
    }
    
    func invalidate() {
        timer.invalidate()
    }
}

// MARK: - Private
private extension TimeUpdater {
    func makeTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.completionSubject.send()
        }
        RunLoop.main.add(timer, forMode: .common)
    }
}
