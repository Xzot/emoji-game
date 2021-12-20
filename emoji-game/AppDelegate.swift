//
//  AppDelegate.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 19.12.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private lazy var provider: DependencyProvider = {
#if DEBUG
        DependencyProvider(
            assembly: DebugAssmebly()
        )
#else
        DependencyProvider(assembly: ProductionAssmebly())
#endif
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let startScene = StartBuilder(provider: provider).build()
        let root = UINavigationController(rootViewController: startScene)
        root.isNavigationBarHidden = true
        window?.rootViewController = root
        window?.makeKeyAndVisible()
        
        return true
    }
}
