//
//  NoAdsPurchaseService.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 27.01.2022.
//

import UIKit
import Combine
import Foundation
import SwiftyStoreKit

// MARK: - AdsState enum
enum AdsState {
    case on
    case off
    
    static var `default`: AdsState { .on }
}

// MARK: - Output
extension NoAdsPurchaseService {
    var adsState: AdsState {
        adsStateSubject.value
    }
    var adsStatePublihser: AnyPublisher<AdsState, Never> {
        adsStateSubject.eraseToAnyPublisher()
    }
}

// MARK: - API
extension NoAdsPurchaseService {
    func tryToRestore(_ completion: (() -> Void)? = nil) {
        retrieveProduct(self.restore(completion))
    }
    
    func purchaseNoAds() {
        guard isProductRetrieved == true else {
            fatalError("WARNING: Should not to purchase before product where retrieved")
        }
        purchase()
    }
}

// MARK: - NoAdsPurchaseService final class
final class NoAdsPurchaseService {
    // MARK: Properties
    private let adsStateSubject = CurrentValueSubject<AdsState, Never>(.default)
    private var isProductRetrieved = false
}

// MARK: - Private
private extension NoAdsPurchaseService {
    func retrieveProduct(_ completion: @autoclosure @escaping () -> Void) {
        SwiftyStoreKit.retrieveProductsInfo(
            [AppConstants.adsPurchaseProductId]
        ) { [weak self] result in
            self?.isProductRetrieved = result.retrievedProducts.first != nil
            completion()
        }
    }
    
    func restore(_ completion: (() -> Void)? = nil) {
        // see notes below for the meaning of Atomic / Non-Atomic
        SwiftyStoreKit.completeTransactions(
            atomically: true
        ) { [weak self] purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                    self?.adsStateSubject.send(.off)
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    fatalError()
                }
            }
            completion?()
        }
    }
    
    func purchase() {
        SwiftyStoreKit.purchaseProduct(
            AppConstants.adsPurchaseProductId
        ) { [weak self] result in
            switch result {
            case .success(_):
                self?.adsStateSubject.send(.off)
            case .error(_):
                self?.tryToRestore()
            }
        }
    }
}
