// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {

  internal enum FinalScene {
    /// CONTINUE
    internal static let continueButtonTitle = Strings.tr("Localizable", "finalScene.continueButtonTitle")
    /// NO, GIVE UP
    internal static let gameOverButtonTitle = Strings.tr("Localizable", "finalScene.gameOverButtonTitle")
  }

  internal enum MainScene {
    /// Who's that
    /// Emoji?
    internal static let labelText = Strings.tr("Localizable", "mainScene.labelText")
    /// PLAY
    internal static let playButtonName = Strings.tr("Localizable", "mainScene.playButtonName")
    /// Best: 
    internal static let playButtonScoreTitle = Strings.tr("Localizable", "mainScene.playButtonScoreTitle")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
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
