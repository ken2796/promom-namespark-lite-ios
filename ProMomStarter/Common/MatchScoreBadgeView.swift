import UIKit

final class MatchScoreBadgeView: UIView {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = ProMomColor.accentSecondary
        layer.cornerRadius = 12

        label.translatesAutoresizingMaskIntoConstraints = false
        label.setPromomText(nil, style: .captionStrong, color: ProMomColor.accentForeground)

        addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(score: Int) {
        label.text = "\(score) Match"
    }
}
