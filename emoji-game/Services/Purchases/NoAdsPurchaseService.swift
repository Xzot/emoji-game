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

// MARK: - API
extension NoAdsPurchaseService {
    func purchaseNoAds() {
        tryToRestore { [weak self] in
            guard
                self?.isProductRetrieved == true,
                self?.state.isHiddenValue(for: .isAdsHidden) == false
            else { return }
            self?.purchase()
        }
    }
    
    func completeTransactions(_ completion: (() -> Void)? = nil) {
        SwiftyStoreKit.completeTransactions() { [weak self] purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    self?.state.set(isHidden: true, for: .isAdsHidden)
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
            completion?()
        }
    }
}

// MARK: - NoAdsPurchaseService final class
final class NoAdsPurchaseService {
    // MARK: Properties
    private var isProductRetrieved = false
    private let state: GASProvider
    
    init(_ state: GASProvider) {
        self.state = state
    }
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
    
    func tryToRestore(_ completion: (() -> Void)? = nil) {
        retrieveProduct(self.restore(completion))
    }
    
    func restore(_ completion: (() -> Void)? = nil) {
        SwiftyStoreKit.restorePurchases() { [weak self] results in
            if results.restoredPurchases.count > 0 {
                self?.state.set(isHidden: true, for: .isAdsHidden)
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
                self?.state.set(isHidden: true, for: .isAdsHidden)
            case .error(_):
                break
            }
        }
    }
}
