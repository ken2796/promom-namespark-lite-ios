import UIKit

final class MessageView: UIView {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ProMomColor.backgroundPrimary
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = ProMomColor.borderDefault.cgColor

        label.translatesAutoresizingMaskIntoConstraints = false
        label.setPromomText(nil, style: .smallBody, color: ProMomColor.textSecondary, numberOfLines: 0)

        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
        ])

        isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(message: String, tintColor: UIColor = ProMomColor.textSecondary) {
        label.text = message
        label.textColor = tintColor
        isHidden = false
    }

    func hide() {
        label.text = nil
        isHidden = true
    }
}
