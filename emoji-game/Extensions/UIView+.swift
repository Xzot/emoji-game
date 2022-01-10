//
//  UIView+PulsingAnimation.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit

extension UIView {
    func pulseAnimated(
        minScale: CGFloat,
        maxScale: CGFloat,
        duration: CGFloat,
        delay: CGFloat
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.repeat, .autoreverse],
            animations: { [weak self] in
                guard let `self` = self else { return }
                let minTransform = CGAffineTransform(scaleX: minScale, y: minScale)
                let maxTransform = CGAffineTransform(scaleX: maxScale, y: maxScale)
                let newTransform = self.transform == minTransform ? maxTransform : minTransform
                self.transform = newTransform
            },
            completion: nil
        )
    }
}

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(
            name: CAMediaTimingFunctionName.easeInEaseOut
        )
        animation.type = CATransitionType.reveal
        animation.duration = duration
        layer.add(
            animation,
            forKey: CATransitionType.fade.rawValue
        )
    }
}
