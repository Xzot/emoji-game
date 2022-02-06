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
    
    enum ExpandAnimationPower {
        case light
        case hard
    }
    
    func decreaseAnimated(_ closure: @escaping () -> Void) {
        UIView.animate(
            withDuration: AppConstants.Animation.shortDuration,
            delay: .zero,
            options: [],
            animations: { [weak self] in
                guard let `self` = self else { return }
                self.transform = CGAffineTransform(
                    scaleX: AppConstants.Animation.decrease,
                    y: AppConstants.Animation.decrease
                )
            },
            completion: { _ in
                closure()
            }
        )
    }
    
    func expandAnimated(_ closure: @escaping () -> Void) {
        UIView.animate(
            withDuration: AppConstants.Animation.shortDuration,
            delay: .zero,
            options: [],
            animations: { [weak self] in
                guard let `self` = self else { return }
                self.transform = CGAffineTransform(
                    scaleX: AppConstants.Animation.expand,
                    y: AppConstants.Animation.expand
                )
            },
            completion: { _ in
                closure()
            }
        )
    }
    
    func backToNormalAnimated(_ closure: @escaping () -> Void) {
        UIView.animate(
            withDuration: AppConstants.Animation.shortDuration,
            delay: 0.4,
            options: [],
            animations: { [weak self] in
                guard let `self` = self else { return }
                self.transform = CGAffineTransform(
                    scaleX: 1,
                    y: 1
                )
            },
            completion: { _ in
                closure()
            }
        )
    }
}

extension UILabel {
    func scoreUpdateAnimated(
        text: String,
        startScale: CGFloat = AppConstants.Animation.decrease,
        endScale: CGFloat = AppConstants.Animation.expand,
        duration: CGFloat = AppConstants.Animation.longDuration,
        delay: CGFloat = 0,
        didEnd: (() -> Void)?
    ) {
        let diff = endScale - startScale
        alpha = 0
        transform = CGAffineTransform(
            scaleX: startScale,
            y: startScale
        )
        self.text = text
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: []) { [weak self] in
            UIView.addKeyframe(
                withRelativeStartTime: 0.0,
                relativeDuration: 0.25
            ) { [weak self] in
                self?.alpha = 1
            }

            UIView.addKeyframe(
                withRelativeStartTime: 0.25,
                relativeDuration: 0.25
            ) { [weak self] in
                let scale = startScale + diff / 4
                self?.transform = CGAffineTransform(
                    scaleX: scale,
                    y: scale
                )
            }

            UIView.addKeyframe(
                withRelativeStartTime: 0.5,
                relativeDuration: 0.25
            ) { [weak self] in
                let scale = startScale + diff / 2
                self?.transform = CGAffineTransform(
                    scaleX: scale,
                    y: scale
                )
            }

            UIView.addKeyframe(
                withRelativeStartTime: 0.75,
                relativeDuration: 0.25
            ) { [weak self] in
                let scale = startScale + diff
                self?.transform = CGAffineTransform(
                    scaleX: scale,
                    y: scale
                )
            }
        } completion: { _ in
            didEnd?()
        }
    }
}
