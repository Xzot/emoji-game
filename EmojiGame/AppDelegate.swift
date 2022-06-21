//
//  AppDelegate.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 19.12.2021.
//

import UIKit
import GoogleMobileAds

import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let provider: DependencyProvider = .standart
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        provider.get(NoAdsPurchaseService.self).completeTransactions(nil)
        
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
