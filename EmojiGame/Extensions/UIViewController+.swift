//
//  UIViewController+.swift
//  Pics (iOS)
//
//  Created by Сергей Сивагин on 28.09.2021.
//

import UIKit
import TinyConstraints

extension UIViewController {
    func integrateChild(
        _ viewController: UIViewController,
        on view: UIView
    ) {
        swapChild(nil, with: viewController, on: view)
    }
    
    func swapChildAnimated(
        _ previousViewController: UIViewController?,
        with newViewController: UIViewController?,
        on view: UIView
    ) {
        if let previousViewController = previousViewController {
            previousViewController.willMove(toParent: nil)
            
            UIView.animate(withDuration: 0.25) {
                previousViewController.view.alpha = 0
            } completion: { _ in
                previousViewController.view.removeFromSuperview()
                previousViewController.removeFromParent()
            }
        }
        
        if let newViewController = newViewController {
            addChild(newViewController)
            newViewController.view.alpha = 0
            view.addSubview(newViewController.view)
            newViewController.view.edgesToSuperview()
            setNeedsStatusBarAppearanceUpdate()
            
            newViewController.didMove(toParent: self)
            
            UIView.animate(withDuration: 0.25, animations: {
                newViewController.view.alpha = 1
            }, completion: nil)
        }
    }
    
    func swapChild(
        _ previousViewController: UIViewController?,
        with newViewController: UIViewController?,
        on view: UIView
    ) {
        if let previousViewController = previousViewController {
            previousViewController.willMove(toParent: nil)
            
            previousViewController.view.removeFromSuperview()
            previousViewController.removeFromParent()
        }
        
        if let newViewController = newViewController {
            addChild(newViewController)
            view.addSubview(newViewController.view)
            newViewController.view.edgesToSuperview()
            setNeedsStatusBarAppearanceUpdate()
            
            newViewController.didMove(toParent: self)
        }
    }
    
    func swapPresented(
        to viewController: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        if let presentedViewController = presentedViewController {
            presentedViewController.dismiss(animated: true, completion: { [weak self] in
                self?.present(viewController, animated: true, completion: completion)
            })
        } else {
            present(viewController, animated: true, completion: completion)
        }
    }
    
    func hidePresentedWithPush(
        to viewController: UIViewController,
        animated: Bool = true,
        failedToPush: (() -> Void)? = nil
    ) {
        if let navigationController = navigationController {
            if let presentedViewController = presentedViewController {
                presentedViewController.dismiss(animated: animated, completion: {
                    navigationController.pushViewController(viewController, animated: animated)
                })
            } else {
                navigationController.pushViewController(viewController, animated: animated)
            }
        } else {
            failedToPush?()
        }
    }
}
