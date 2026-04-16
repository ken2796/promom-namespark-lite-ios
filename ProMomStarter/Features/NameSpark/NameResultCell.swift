import UIKit

final class NameResultCell: UITableViewCell {
    static let reuseIdentifier = "NameResultCell"

    private let cardView = UIView()
    private let nameLabel = UILabel()
    private let meaningLabel = UILabel()
    private let metadataLabel = UILabel()
    private let favoriteLabel = UILabel()
    private let scoreBadgeView = MatchScoreBadgeView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.applyPromomCardStyle()

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.setPromomText(nil, style: .bodyStrong)

        meaningLabel.translatesAutoresizingMaskIntoConstraints = false
        meaningLabel.setPromomText(nil, style: .smallBody, color: ProMomColor.textSecondary, numberOfLines: 0)

        metadataLabel.translatesAutoresizingMaskIntoConstraints = false
        metadataLabel.setPromomText(nil, style: .caption, color: ProMomColor.textInactive)

        favoriteLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteLabel.setPromomText(nil, style: .captionStrong, color: ProMomColor.accent)
        favoriteLabel.textAlignment = .right

        scoreBadgeView.translatesAutoresizingMaskIntoConstraints = false

        let topRow = UIStackView(arrangedSubviews: [nameLabel, UIView(), scoreBadgeView])
        topRow.translatesAutoresizingMaskIntoConstraints = false
        topRow.alignment = .center
        topRow.spacing = 12

        let footerRow = UIStackView(arrangedSubviews: [metadataLabel, UIView(), favoriteLabel])
        footerRow.translatesAutoresizingMaskIntoConstraints = false
        footerRow.alignment = .center
        footerRow.spacing = 12

        cardView.addSubview(topRow)
        cardView.addSubview(meaningLabel)
        cardView.addSubview(footerRow)
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            topRow.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            topRow.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            topRow.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            meaningLabel.topAnchor.constraint(equalTo: topRow.bottomAnchor, constant: 10),
            meaningLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            meaningLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            footerRow.topAnchor.constraint(equalTo: meaningLabel.bottomAnchor, constant: 14),
            footerRow.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            footerRow.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            footerRow.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with result: NameSearchResult) {
        nameLabel.text = result.name
        meaningLabel.text = result.meaning
        metadataLabel.text = result.metadataLine
        favoriteLabel.text = result.isFavorite ? "Saved" : "Tap for details"
        scoreBadgeView.configure(score: result.matchScore)
    }
}
