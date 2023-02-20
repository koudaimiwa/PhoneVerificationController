// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Button {
    /// キャンセル
    internal static let cancel = L10n.tr("Localizable", "button.cancel")
    /// 送信する
    internal static let send = L10n.tr("Localizable", "button.send")
    /// 再送信
    internal static let tryAgain = L10n.tr("Localizable", "button.try-again")
    /// 確認する
    internal static let verify = L10n.tr("Localizable", "button.verify")
  }

  internal enum Description {
    /// 確認コードを入力してください
    internal static let code = L10n.tr("Localizable", "description.code")
    /// 電話番号を入力してください
    internal static let phone = L10n.tr("Localizable", "description.phone")
  }

  internal enum Message {
    /// 成功です!
    internal static let success = L10n.tr("Localizable", "message.success")
  }

  internal enum Placeholder {
    /// 電話番号
    internal static let phone = L10n.tr("Localizable", "placeholder.phone")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: PhoneVerificationController.bundle, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
