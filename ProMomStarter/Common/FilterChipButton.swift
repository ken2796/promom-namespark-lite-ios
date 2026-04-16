import UIKit

final class FilterChipButton: UIButton {
    var isFilterSelected = false {
        didSet {
            updateAppearance()
        }
    }

    init(title: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 12
        layer.borderWidth = 1
        titleLabel?.font = ProMomTypography.smallBodyStrong.font
        if #available(iOS 15.0, *) {
            var buttonConfiguration = configuration ?? .plain()
            buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)
            configuration = buttonConfiguration
        } else {
            contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        }
        setTitle(title, for: .normal)
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateAppearance() {
        backgroundColor = isFilterSelected ? ProMomColor.accentSecondary : ProMomColor.backgroundSecondary
        layer.borderColor = (isFilterSelected ? ProMomColor.accent : ProMomColor.borderDefault).cgColor
        setTitleColor(isFilterSelected ? ProMomColor.accentForeground : ProMomColor.textSecondary, for: .normal)
    }
}
