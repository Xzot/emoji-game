//
//  SwapChildViewController.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 02.01.2022.
//

import UIKit

// MARK: - SwapChildViewController class
class SwapChildViewController: UIViewController {
    // MARK: Properties
    private var currentViewController: UIViewController?
    
    // MARK: API
    func swapCurrentChild(with newViewController: UIViewController) {
        swapChildAnimated(currentViewController, with: newViewController, on: view)
        currentViewController = newViewController
        newViewController.view.centerInSuperview()
        newViewController.view.size(to: view)
    }

}
