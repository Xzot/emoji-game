//
//  NSMutableAttributedString+.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 09.01.2022.
//

import UIKit

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .numeric)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
}
