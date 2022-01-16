//
//  UIDevice+.swift
//  emoji-game
//
//  Created by Vlad Shchuka on 01.01.2022.
//

import UIKit

// MARK: - UIDevice public extension
public extension UIDevice {
    static var sizeType: SizeType {
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                return .iPhone_5_5S_5C_SE1
            case 1334:
                return .iPhone_6_6S_7_8_SE2
            case 1920, 2208:
                return .iPhone_6Plus_6SPlus_7Plus_8Plus
            case 2340:
                return .iPhone_13mini
            case 2436:
                return .iPhone_X_XS_11Pro_12mini
            case 2532:
                return .iPhone_12Pro
            case 2688:
                return .iPhone_XSMax_11ProMax
            case 2778:
                return .iPhone_12ProMax
            case 1792:
                return .iPhone_XR_11
            default:
                assertionFailure("Unsupported phone device detected!")
                return .iPhone_6_6S_7_8_SE2
            }
        } else {
            assertionFailure("Unsupported idiom device detected!")
            return .iPhone_6_6S_7_8_SE2
        }
    }
    
    static var hasHomeButton: Bool {
        return !SizeType.notch.contains(sizeType)
    }
    
    static var isXType: Bool {
        return SizeType.notch.contains(sizeType)
    }
    
    static var isSmall: Bool {
        return sizeType == .iPhone_5_5S_5C_SE1
    }
    
    static func value<T>(from values: [SizeType: T], defaultValue: T? = nil) -> T {
        // swiftlint:disable:next force_unwrapping
        return values[Self.sizeType] ?? defaultValue ?? values[.iPhone_6_6S_7_8_SE2]!
    }
    
    static let sizeFactor: CGFloat = sizeFactorFor(sizeType: UIDevice.sizeType)
    static func sizeFactorFor(sizeType: SizeType) -> CGFloat {
        return sizeType == SizeType.iPhone_X_XS_11Pro_12mini
            || sizeType == SizeType.iPhone_XSMax_11ProMax
            || sizeType == SizeType.iPhone_XR_11 ?
            UIScreen.main.bounds.width / 375 :
            UIScreen.main.bounds.height / 812
    }
}

// MARK: - SizeType
public extension UIDevice {
    enum SizeType: String, CaseIterable {
        case iPhone_5_5S_5C_SE1
        case iPhone_6_6S_7_8_SE2
        case iPhone_6Plus_6SPlus_7Plus_8Plus
        
        case iPhone_X_XS_11Pro_12mini
        case iPhone_13mini
        case iPhone_XR_11
        case iPhone_XSMax_11ProMax
        case iPhone_12Pro
        case iPhone_12ProMax
        
        static var notch: [SizeType] = [
            iPhone_X_XS_11Pro_12mini,
            iPhone_13mini,
            iPhone_XR_11,
            iPhone_XSMax_11ProMax,
            iPhone_12Pro,
            iPhone_12ProMax,
        ]
    }
}
