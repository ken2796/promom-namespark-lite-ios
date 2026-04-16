import UIKit

enum ProMomColor {
    static let backgroundTertiary = UIColor(hex: "#EEEEEE")
    static let backgroundSecondary = UIColor(hex: "#F5F5F5")
    static let backgroundPrimary = UIColor(hex: "#FFFFFF")
    static let backgroundInactive = UIColor(hex: "#CDCFCE")
    static let borderDefault = UIColor(hex: "#E6E7E6")
    static let textPrimary = UIColor(hex: "#060F09")
    static let textSecondary = UIColor(hex: "#393F3B")
    static let textInactive = UIColor(hex: "#9C9F9D")
    static let accent = UIColor(hex: "#2FA364")
    static let accentSecondary = UIColor(hex: "#D5EDE0")
    static let accentForeground = UIColor(hex: "#070F0A")
    static let shadow = UIColor(hex: "#070F0A", alpha: 0.12)
    static let warning = UIColor.systemRed
}

enum ProMomTypography {
    case heroTitle
    case sectionTitle
    case bodyStrong
    case bodyParagraph
    case smallBodyStrong
    case smallBody
    case captionStrong
    case caption

    var font: UIFont {
        switch self {
        case .heroTitle:
            return ProMomFont.font(size: 28, weight: .medium)
        case .sectionTitle:
            return ProMomFont.font(size: 20, weight: .medium)
        case .bodyStrong:
            return ProMomFont.font(size: 16, weight: .medium)
        case .bodyParagraph:
            return ProMomFont.font(size: 16, weight: .regular)
        case .smallBodyStrong:
            return ProMomFont.font(size: 14, weight: .medium)
        case .smallBody:
            return ProMomFont.font(size: 14, weight: .regular)
        case .captionStrong:
            return ProMomFont.font(size: 12, weight: .medium)
        case .caption:
            return ProMomFont.font(size: 12, weight: .regular)
        }
    }
}

private enum ProMomFont {
    enum Weight {
        case regular
        case medium
        case semibold

        var postScriptName: String {
            switch self {
            case .regular:
                return "Rubik-Regular"
            case .medium:
                return "Rubik-Medium"
            case .semibold:
                return "Rubik-SemiBold"
            }
        }

        var systemWeight: UIFont.Weight {
            switch self {
            case .regular:
                return .regular
            case .medium:
                return .medium
            case .semibold:
                return .semibold
            }
        }
    }

    static func font(size: CGFloat, weight: Weight) -> UIFont {
        if let custom = UIFont(name: weight.postScriptName, size: size) {
            return custom
        }

        return UIFont.systemFont(ofSize: size, weight: weight.systemWeight)
    }
}

enum ProMomButtonStyle {
    case primary
    case secondary
}

extension UILabel {
    func setPromomText(
        _ text: String?,
        style: ProMomTypography,
        color: UIColor = ProMomColor.textPrimary,
        numberOfLines: Int = 1
    ) {
        self.text = text
        font = style.font
        textColor = color
        self.numberOfLines = numberOfLines
    }
}

extension UIButton {
    func applyPromomButtonStyle(_ style: ProMomButtonStyle) {
        titleLabel?.font = ProMomTypography.bodyStrong.font
        layer.cornerRadius = 12
        layer.masksToBounds = true
        if #available(iOS 15.0, *) {
            var buttonConfiguration = configuration ?? .plain()
            buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 18, bottom: 14, trailing: 18)
            configuration = buttonConfiguration
        } else {
            contentEdgeInsets = UIEdgeInsets(top: 14, left: 18, bottom: 14, right: 18)
        }

        switch style {
        case .primary:
            backgroundColor = ProMomColor.accentSecondary
            setTitleColor(ProMomColor.accentForeground, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = ProMomColor.accent.cgColor
        case .secondary:
            backgroundColor = ProMomColor.backgroundPrimary
            setTitleColor(ProMomColor.textPrimary, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = ProMomColor.borderDefault.cgColor
        }
    }

    func setPromomTitle(_ title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = ProMomTypography.bodyStrong.font
    }
}

extension UIView {
    func applyPromomCardStyle(cornerRadius: CGFloat = 16) {
        backgroundColor = ProMomColor.backgroundPrimary
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 1
        layer.borderColor = ProMomColor.borderDefault.cgColor
        layer.shadowColor = ProMomColor.shadow.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        clipsToBounds = false
    }
}

extension UITextField {
    func applyPromomInputStyle(placeholder: String) {
        font = ProMomTypography.bodyParagraph.font
        textColor = ProMomColor.textPrimary
        backgroundColor = ProMomColor.backgroundPrimary
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = ProMomColor.borderDefault.cgColor
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: ProMomTypography.bodyParagraph.font,
                .foregroundColor: ProMomColor.textInactive,
            ]
        )
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 44))
        leftViewMode = .always
        autocorrectionType = .no
        autocapitalizationType = .allCharacters
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        let cleaned = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: cleaned)
        var value: UInt64 = 0
        scanner.scanHexInt64(&value)

        let red = CGFloat((value & 0xFF0000) >> 16) / 255
        let green = CGFloat((value & 0x00FF00) >> 8) / 255
        let blue = CGFloat(value & 0x0000FF) / 255

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
