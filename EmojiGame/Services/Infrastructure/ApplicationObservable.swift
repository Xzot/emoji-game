//
//  ApplicationObservable.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 19.12.2021.
//

import UIKit

protocol ApplicationObservable {
    func applicationWillEnterForeground(_ application: UIApplication)
    func applicationDidEnterBackground(_ application: UIApplication)
}

extension ApplicationObservable {
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Empty
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Empty
    }
}
