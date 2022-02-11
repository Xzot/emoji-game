//
//  GlobalAppState.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 16.01.2022.
//

import Combine
import Foundation
import SwiftyUserDefaults

// MARK: - GlobalAppState
enum GlobalAppState {
    case isAdsHidden
    case isSoundsHidden
}

// MARK: - GlobalAppState
final class GASProvider {
    // MARK: Properties
    private let isAdsHiddenState = CurrentValueSubject<Bool, Never>(Defaults[\.isAdsHidden])
    private let isSoundsHiddenState = CurrentValueSubject<Bool, Never>(Defaults[\.isSoundsHidden])
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: API
    func publisher(for type: GlobalAppState) -> AnyPublisher<Bool, Never> {
        switch type {
        case .isAdsHidden:
            return isAdsHiddenState.eraseToAnyPublisher()
        case .isSoundsHidden:
            return isSoundsHiddenState.eraseToAnyPublisher()
        }
    }
    
    func isHiddenValue(for type: GlobalAppState) -> Bool {
        switch type {
        case .isAdsHidden:
            return isAdsHiddenState.value
        case .isSoundsHidden:
            return isSoundsHiddenState.value
        }
    }
    
    func set(isHidden value: Bool, for type: GlobalAppState) {
        switch type {
        case .isAdsHidden:
            isAdsHiddenState.send(value)
        case .isSoundsHidden:
            isSoundsHiddenState.send(value)
        }
    }
    
    func revert(_ type: GlobalAppState) {
        switch type {
        case .isAdsHidden:
            isAdsHiddenState.send(!isAdsHiddenState.value)
        case .isSoundsHidden:
            isSoundsHiddenState.send(!isSoundsHiddenState.value)
        }
    }
    
    // MARK: Life Cycle
    init() {
        self.isAdsHiddenState
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { value in
                Defaults[\.isAdsHidden] = value
            }
            .store(in: &cancellable)
        
        self.isSoundsHiddenState
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { value in
                Defaults[\.isSoundsHidden] = value
            }
            .store(in: &cancellable)
    }
}
