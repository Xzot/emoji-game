//
//  SelectableTransform.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 11.01.2022.
//

import UIKit

protocol SelectableTransform: UIView {
    func setIsHighlighted(_ value: Bool)
}

extension SelectableTransform {
    func setIsHighlighted(_ value: Bool) {
        if value == true {
            let maxTransform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            transform = maxTransform
        } else {
            let minTransform = CGAffineTransform(scaleX: 1, y: 1)
            transform = minTransform
        }
    }
}
