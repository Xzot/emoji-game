//
//  AppDelegate.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 19.12.2021.
//

import UIKit
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let provider: DependencyProvider = .standart
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        provider.get(NoAdsPurchaseService.self).completeTransactions(nil)
        
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["90f1ee3e8b40010acb7fd8a343e3300c"]
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        application.statusBarStyle = .darkContent
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let startScene = StartBuilder(provider: provider).build()
        let root = UINavigationController(rootViewController: startScene)
        root.isNavigationBarHidden = true
        window?.rootViewController = root
        window?.makeKeyAndVisible()
        
        return true
    }
}
