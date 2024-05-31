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
            case 960:
                return .iPhone4
            case 1136:
                return .iPhone5_SE
            case 1334:
                return .iPhone6_7_8_SE2_SE3
            case 1792:
                return .iPhoneXr_11
            case 1920:
                return .iPhone6Plus_7Plus_8Plus
            case 2340:
                return .iPhone12Mini_13Mini
            case 2436:
                return .iPhoneX_XS_11Pro
            case 2532:
                return .iPhone12Pro_12_13Pro_13_14
            case 2556:
                return .iPhone14Pro
            case 2688:
                return .iPhoneXsMax_11ProMax
            case 2778:
                return .iPhone12ProMax_13ProMax_14Plus
            case 2796:
                return .iPhone14ProMax
            default:
                assertionFailure("Unsupported phone device detected!")
                return .iPhone6_7_8_SE2_SE3
            }
        } else {
            assertionFailure("Unsupported idiom device detected!")
            return .iPhone6_7_8_SE2_SE3
        }
    }
    
    static var hasHomeButton: Bool {
        return !SizeType.notch.contains(sizeType)
    }
    
    static var isXType: Bool {
        return SizeType.notch.contains(sizeType)
    }
    
    static var isSmall: Bool {
        return sizeType == .iPhone5_SE || sizeType == .iPhone4
    }
    
    static func value<T>(from values: [SizeType: T], defaultValue: T? = nil) -> T {
        // swiftlint:disable:next force_unwrapping
        return values[Self.sizeType] ?? defaultValue ?? values[.iPhone6_7_8_SE2_SE3]!
    }
    
    static let sizeFactor: CGFloat = sizeFactorFor(sizeType: UIDevice.sizeType)
    static func sizeFactorFor(sizeType: SizeType) -> CGFloat {
        return sizeType == SizeType.iPhoneX_XS_11Pro
        || sizeType == SizeType.iPhone12Mini_13Mini
        || sizeType == SizeType.iPhoneXsMax_11ProMax
        || sizeType == SizeType.iPhoneXr_11 ?
        UIScreen.main.bounds.width / 375 :
        UIScreen.main.bounds.height / 812
    }
}

// MARK: - SizeType
public extension UIDevice {
    enum SizeType: String, CaseIterable {
        case iPhone4
        case iPhone5_SE
        case iPhone6_7_8_SE2_SE3
        case iPhoneXr_11
        case iPhone6Plus_7Plus_8Plus
        case iPhone12Mini_13Mini
        case iPhoneX_XS_11Pro
        case iPhone12Pro_12_13Pro_13_14
        case iPhone14Pro
        case iPhoneXsMax_11ProMax
        case iPhone12ProMax_13ProMax_14Plus
        case iPhone14ProMax
        
        static var notch: [SizeType] = [
            iPhoneXr_11,
            iPhone12Mini_13Mini,
            iPhoneX_XS_11Pro,
            iPhone12Pro_12_13Pro_13_14,
            iPhone14Pro,
            iPhoneXsMax_11ProMax,
            iPhone12ProMax_13ProMax_14Plus,
            iPhone14ProMax
        ]
    }
}
