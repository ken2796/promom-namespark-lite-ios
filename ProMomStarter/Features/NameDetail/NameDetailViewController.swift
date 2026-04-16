import UIKit

@MainActor
final class NameDetailViewController: UIViewController {
    private let viewModel: NameDetailViewModel

    private let scrollView = UIScrollView()
    private let cardView = UIView()
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let metadataStack = UIStackView()
    private let genderLabel = InsetLabel()
    private let originLabel = InsetLabel()
    private let meaningTitleLabel = UILabel()
    private let meaningLabel = UILabel()
    private let stylesTitleLabel = UILabel()
    private let stylesLabel = UILabel()
    private let popularityTitleLabel = UILabel()
    private let popularityLabel = UILabel()
    private let insightTitleLabel = UILabel()
    private let insightLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    private let messageView = MessageView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)

    init(viewModel: NameDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.seedName
        view.backgroundColor = ProMomColor.backgroundTertiary
        configureSubviews()
        configureLayout()

        viewModel.delegate = self
        viewModel.viewDidLoad()
    }

    private func configureSubviews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.applyPromomCardStyle()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 14

        nameLabel.setPromomText(viewModel.seedName, style: .heroTitle, numberOfLines: 0)

        metadataStack.translatesAutoresizingMaskIntoConstraints = false
        metadataStack.axis = .horizontal
        metadataStack.spacing = 8

        [genderLabel, originLabel].forEach { label in
            label.backgroundColor = ProMomColor.backgroundSecondary
            label.layer.cornerRadius = 12
            label.layer.masksToBounds = true
            label.setPromomText(nil, style: .captionStrong, color: ProMomColor.textSecondary)
            metadataStack.addArrangedSubview(label)
        }

        meaningTitleLabel.setPromomText("Meaning", style: .captionStrong, color: ProMomColor.textSecondary)
        meaningLabel.setPromomText("Finish this detail flow.", style: .bodyParagraph, numberOfLines: 0)

        stylesTitleLabel.setPromomText("Style", style: .captionStrong, color: ProMomColor.textSecondary)
        stylesLabel.setPromomText(nil, style: .bodyParagraph, numberOfLines: 0)

        popularityTitleLabel.setPromomText("Popularity", style: .captionStrong, color: ProMomColor.textSecondary)
        popularityLabel.setPromomText(nil, style: .bodyParagraph, numberOfLines: 0)

        insightTitleLabel.setPromomText("Insight", style: .captionStrong, color: ProMomColor.textSecondary)
        insightLabel.setPromomText(nil, style: .bodyParagraph, numberOfLines: 0)

        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.applyPromomButtonStyle(.secondary)
        favoriteButton.setPromomTitle("Save to favorites")
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        messageView.translatesAutoresizingMaskIntoConstraints = false

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = ProMomColor.textPrimary
    }

    private func configureLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(cardView)
        cardView.addSubview(stackView)
        view.addSubview(messageView)
        view.addSubview(loadingIndicator)

        [
            nameLabel,
            metadataStack,
            meaningTitleLabel,
            meaningLabel,
            stylesTitleLabel,
            stylesLabel,
            popularityTitleLabel,
            popularityLabel,
            insightTitleLabel,
            insightLabel,
            favoriteButton,
        ].forEach { stackView.addArrangedSubview($0) }

        let guide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 12),
            messageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            messageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),

            scrollView.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

            cardView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            cardView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),

            favoriteButton.heightAnchor.constraint(equalToConstant: 52),

            loadingIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
        ])
    }

    @objc
    private func favoriteTapped() {
        viewModel.toggleFavorite()
    }

    private func render() {
        let state = viewModel.state

        if state.isLoading || state.isSaving {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }

        // Hide the card while the initial load is in flight so we never show
        // stale placeholder text. Once detail arrives it stays visible.
        scrollView.isHidden = state.detail == nil && state.isLoading

        if let detail = state.detail {
            title = detail.name
            nameLabel.text = detail.name
            genderLabel.text = detail.gender.displayTitle
            originLabel.text = detail.origin.displayTitle
            meaningLabel.text = detail.meaning
            stylesLabel.text = detail.stylesLine
            popularityLabel.text = detail.popularity
            insightLabel.text = detail.insight

            let isFavorite = detail.isFavorite
            favoriteButton.setPromomTitle(isFavorite ? "Saved to favorites" : "Save to favorites")
            favoriteButton.applyPromomButtonStyle(isFavorite ? .primary : .secondary)
        }

        if let errorMessage = state.errorMessage {
            messageView.show(message: errorMessage, tintColor: ProMomColor.warning)
        } else {
            messageView.hide()
        }

        let canInteract = state.detail != nil && !state.isSaving
        favoriteButton.isEnabled = canInteract
        favoriteButton.alpha = canInteract ? 1 : 0.6
    }
}

extension NameDetailViewController: NameDetailViewModelDelegate {
    func nameDetailViewModelDidUpdate(_ viewModel: NameDetailViewModel) {
        render()
    }
}
