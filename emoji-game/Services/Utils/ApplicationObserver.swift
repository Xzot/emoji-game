//
//  ApplicationObserver.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 09.02.2022.
//

import UIKit
import Foundation
import Combine

enum AppEvent {
    case willEnterForeground
    case didEnterBackground
}

protocol AppEventProvider: ApplicationObservable {
    var eventPublisher: AnyPublisher<AppEvent, Never> { get }
}

final class ApplicationObserver: AppEventProvider {
    var eventPublisher: AnyPublisher<AppEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    private var eventSubject = PassthroughSubject<AppEvent, Never>()
}

extension ApplicationObserver {
    func applicationWillEnterForeground(_ application: UIApplication) {
        eventSubject.send(.willEnterForeground)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        eventSubject.send(.didEnterBackground)
    }
}
