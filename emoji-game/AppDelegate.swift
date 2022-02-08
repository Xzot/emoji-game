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
        
#if DEBUG
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["9781f58f58fbbb161f99261469294b22"]
#else
#endif
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let startScene = StartBuilder(provider: provider).build()
        let root = UINavigationController(rootViewController: startScene)
        root.isNavigationBarHidden = true
        window?.rootViewController = root
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        provider.applicationObservableServices.forEach {
            $0.applicationWillEnterForeground(application)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        provider.applicationObservableServices.forEach {
            $0.applicationDidEnterBackground(application)
        }
    }
}
