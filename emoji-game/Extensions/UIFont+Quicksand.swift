//
//  UIFont+Quicksand.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit

extension UIFont {
    class func quicksand(ofSize fontSize: CGFloat, weight: UIFont.QuicksandWeight) -> UIFont {
        return UIFont(
            name: "Quicksand-\(weight.rawValue)",
            size: fontSize
        )!
    }
}

extension UIFont {
    enum QuicksandWeight: String {
        case bold = "Bold"
        case light = "Light"
        case medium = "Medium"
        case regular = "Regular"
        case semibold = "SemiBold"
    }
}
