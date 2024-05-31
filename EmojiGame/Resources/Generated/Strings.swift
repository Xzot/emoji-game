// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum FinalScene {
    /// CONTINUE
    internal static let continueButtonTitle = Strings.tr("Localizable", "finalScene.continueButtonTitle", fallback: "CONTINUE")
    /// NO, GIVE UP
    internal static let gameOverButtonTitle = Strings.tr("Localizable", "finalScene.gameOverButtonTitle", fallback: "NO, GIVE UP")
  }
  internal enum MainScene {
    /// Best score: 
    internal static let bestScoreButtonScoreTitle = Strings.tr("Localizable", "mainScene.bestScoreButtonScoreTitle", fallback: "Best score: ")
    /// INFINITE
    internal static let infiniteButtonName = Strings.tr("Localizable", "mainScene.infiniteButtonName", fallback: "INFINITE")
    /// Emoji Mix
    internal static let labelText = Strings.tr("Localizable", "mainScene.labelText", fallback: "Emoji Mix")
    /// Restore purchase
    internal static let restorePurchaseButtonScoreTitle = Strings.tr("Localizable", "mainScene.restorePurchaseButtonScoreTitle", fallback: "Restore purchase")
    /// TIME ATTACK
    internal static let timeAttackButtonName = Strings.tr("Localizable", "mainScene.timeAttackButtonName", fallback: "TIME ATTACK")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
