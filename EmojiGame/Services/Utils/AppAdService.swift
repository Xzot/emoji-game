//
//  AppAdService.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 14.01.2022.
//

import UIKit
import Combine
import GoogleMobileAds

// MARK: - AppAdService class
final class AppAdService: NSObject {
    // MARK: Properties
    private var completion: (() -> Void)?
    private var interstitialAdQueue = Queue<GADInterstitialAd>()
    private var latestUsedAdd: GADInterstitialAd?
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: API
    func prefetchAds() {
        fetchInterstitialAd()
    }
    
    func showInterstitialAd(
        for scene: UIViewController,
        with completion: @escaping () -> Void
    ) {
        if let interstitialAd = interstitialAdQueue.dequeue() {
            latestUsedAdd = interstitialAd
            interstitialAd.fullScreenContentDelegate = self
            self.completion = completion
            interstitialAd.present(fromRootViewController: scene)
        } else {
            completion()
        }
    }
    
    // MARK: Life Cycle
    override init() {
        super.init()
        self.bind()
    }
}

// MARK: - GADFullScreenContentDelegate
extension AppAdService: GADFullScreenContentDelegate {
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if let completion = self.completion {
            self.completion = nil
            completion()
        }
    }
    
    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        if let completion = self.completion {
            self.completion = nil
            completion()
        }
    }
}

// MARK: - Private
private extension AppAdService {
    func bind() {
        interstitialAdQueue.listCount
            .dropFirst()
            .sink { [weak self] count in
                guard count < 5 else { return }
                self?.fetchInterstitialAd()
            }
            .store(in: &cancellable)
    }
    
    func fetchInterstitialAd() {
        GADInterstitialAd.load(
            withAdUnitID: AppConstants.adUnitId,
            request: GADRequest()
        ) { [weak self] fetchedAd, error in
            guard let fetchedAd = fetchedAd else { return }
            self?.interstitialAdQueue.enqueue(fetchedAd)
        }
    }
}
