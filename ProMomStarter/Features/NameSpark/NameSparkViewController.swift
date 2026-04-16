import UIKit

@MainActor
final class NameSparkViewController: UIViewController {
    var onSelectResult: ((NameSearchResult) -> Void)?

    private let viewModel: NameSparkViewModel

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let headerContainerView = UIView()
    private let headerStackView = UIStackView()
    private let heroLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let filterCardView = UIView()
    private let genderLabel = UILabel()
    private let genderControl = UISegmentedControl(items: ["Any", "Girl", "Boy", "Unisex"])
    private let originLabel = UILabel()
    private let originRowsStack = UIStackView()
    private let startingLetterLabel = UILabel()
    private let startingLetterField = UITextField()
    private let startingLetterWarningLabel = UILabel()
    private let findButton = UIButton(type: .system)
    private let resultsLabel = UILabel()
    private let messageView = MessageView()

    private var originButtons: [NameOrigin: FilterChipButton] = [:]

    init(viewModel: NameSparkViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "NameSpark Lite"
        view.backgroundColor = ProMomColor.backgroundTertiary
        configureNavigationBar()
        configureSubviews()
        configureLayout()

        viewModel.delegate = self
        viewModel.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableHeaderLayout()
    }

    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = ProMomColor.backgroundTertiary
        appearance.titleTextAttributes = [
            .foregroundColor: ProMomColor.textPrimary,
            .font: ProMomTypography.bodyStrong.font,
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = ProMomColor.textPrimary
    }

    private func configureSubviews() {
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.axis = .vertical
        headerStackView.spacing = 18
        headerStackView.isLayoutMarginsRelativeArrangement = true
        headerStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        heroLabel.setPromomText("Find names for your shortlist.", style: .heroTitle, numberOfLines: 0)

        subtitleLabel.setPromomText(
            "Pick filters and tap Find names to discover name ideas.",
            style: .smallBody,
            color: ProMomColor.textSecondary,
            numberOfLines: 0
        )

        filterCardView.applyPromomCardStyle()

        genderLabel.setPromomText("Gender", style: .captionStrong, color: ProMomColor.textSecondary)

        genderControl.selectedSegmentIndex = 0
        genderControl.selectedSegmentTintColor = ProMomColor.accentSecondary
        genderControl.backgroundColor = ProMomColor.backgroundSecondary
        genderControl.setTitleTextAttributes([
            .font: ProMomTypography.smallBody.font,
            .foregroundColor: ProMomColor.textSecondary,
        ], for: .normal)
        genderControl.setTitleTextAttributes([
            .font: ProMomTypography.smallBodyStrong.font,
            .foregroundColor: ProMomColor.textPrimary,
        ], for: .selected)
        genderControl.addTarget(self, action: #selector(genderChanged), for: .valueChanged)

        originLabel.setPromomText("Origins", style: .captionStrong, color: ProMomColor.textSecondary)

        originRowsStack.axis = .vertical
        originRowsStack.spacing = 8

        let firstRow = UIStackView()
        firstRow.axis = .horizontal
        firstRow.spacing = 8
        firstRow.distribution = .fillEqually

        let secondRow = UIStackView()
        secondRow.axis = .horizontal
        secondRow.spacing = 8
        secondRow.distribution = .fillEqually

        for (index, origin) in NameOrigin.allCases.enumerated() {
            let button = FilterChipButton(title: origin.displayTitle)
            button.addTarget(self, action: #selector(originTapped(_:)), for: .touchUpInside)
            button.tag = index
            originButtons[origin] = button

            if index < 2 {
                firstRow.addArrangedSubview(button)
            } else {
                secondRow.addArrangedSubview(button)
            }
        }

        originRowsStack.addArrangedSubview(firstRow)
        originRowsStack.addArrangedSubview(secondRow)

        startingLetterLabel.setPromomText("Starting letter", style: .captionStrong, color: ProMomColor.textSecondary)

        startingLetterField.applyPromomInputStyle(placeholder: "A")
        startingLetterField.addTarget(self, action: #selector(startingLetterChanged), for: .editingChanged)

        startingLetterWarningLabel.setPromomText(nil, style: .caption, color: ProMomColor.warning, numberOfLines: 0)
        startingLetterWarningLabel.isHidden = true

        findButton.applyPromomButtonStyle(.primary)
        findButton.setPromomTitle("Find names")
        findButton.addTarget(self, action: #selector(findTapped), for: .touchUpInside)

        resultsLabel.setPromomText("Results", style: .sectionTitle)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.keyboardDismissMode = .onDrag
        tableView.sectionHeaderTopPadding = 0
        tableView.register(NameResultCell.self, forCellReuseIdentifier: NameResultCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 128

        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = ProMomColor.textPrimary

        [
            genderLabel,
            genderControl,
            originLabel,
            originRowsStack,
            startingLetterLabel,
            startingLetterField,
            startingLetterWarningLabel,
            findButton,
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false

        let filterStack = UIStackView(arrangedSubviews: [
            genderLabel,
            genderControl,
            originLabel,
            originRowsStack,
            startingLetterLabel,
            startingLetterField,
            startingLetterWarningLabel,
            findButton,
        ])
        filterStack.translatesAutoresizingMaskIntoConstraints = false
        filterStack.axis = .vertical
        filterStack.spacing = 8
        filterCardView.addSubview(filterStack)

        [heroLabel, subtitleLabel, filterCardView, resultsLabel, messageView].forEach {
            headerStackView.addArrangedSubview($0)
        }

        headerContainerView.addSubview(headerStackView)
        tableView.tableHeaderView = headerContainerView

        NSLayoutConstraint.activate([
            filterStack.topAnchor.constraint(equalTo: filterCardView.topAnchor, constant: 18),
            filterStack.leadingAnchor.constraint(equalTo: filterCardView.leadingAnchor, constant: 18),
            filterStack.trailingAnchor.constraint(equalTo: filterCardView.trailingAnchor, constant: -18),
            filterStack.bottomAnchor.constraint(equalTo: filterCardView.bottomAnchor, constant: -18),

            startingLetterField.heightAnchor.constraint(equalToConstant: 48),
            findButton.heightAnchor.constraint(equalToConstant: 52),

            headerStackView.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            headerStackView.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
        ])
    }

    private func configureLayout() {
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)

        let guide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
        ])
    }

    private func updateTableHeaderLayout() {
        let width = tableView.bounds.width
        guard width > 0 else { return }

        if headerContainerView.frame.width != width {
            headerContainerView.frame.size.width = width
        }

        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let height = headerContainerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height

        guard headerContainerView.frame.height != height else { return }

        headerContainerView.frame.size.height = height
        tableView.tableHeaderView = headerContainerView
    }

    @objc
    private func genderChanged() {
        viewModel.setGender(at: genderControl.selectedSegmentIndex)
    }

    @objc
    private func originTapped(_ sender: UIButton) {
        guard NameOrigin.allCases.indices.contains(sender.tag) else { return }
        viewModel.toggleOrigin(NameOrigin.allCases[sender.tag])
    }

    @objc
    private func startingLetterChanged() {
        viewModel.updateStartingLetter(startingLetterField.text ?? "")
        if startingLetterField.text != viewModel.state.startingLetter {
            startingLetterField.text = viewModel.state.startingLetter
        }
    }

    @objc
    private func findTapped() {
        view.endEditing(true)
        viewModel.findNames()
    }

    private func render() {
        if viewModel.state.isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }

        genderControl.selectedSegmentIndex = selectedGenderIndex

        for (origin, button) in originButtons {
            button.isFilterSelected = viewModel.state.selectedOrigins.contains(origin)
        }

        startingLetterField.text = viewModel.state.startingLetter

        if let warning = viewModel.state.startingLetterWarning {
            startingLetterWarningLabel.text = warning
            startingLetterWarningLabel.isHidden = false
        } else {
            startingLetterWarningLabel.isHidden = true
        }

        findButton.isEnabled = viewModel.isFindButtonEnabled
        findButton.alpha = viewModel.isFindButtonEnabled ? 1 : 0.55

        if let errorMessage = viewModel.state.errorMessage {
            messageView.show(message: errorMessage, tintColor: ProMomColor.warning)
        } else if viewModel.state.isLoading {
            messageView.show(message: "Searching names…", tintColor: ProMomColor.textSecondary)
        } else if viewModel.state.results.isEmpty {
            let helperMessage = viewModel.state.hasPerformedSearch
                ? "No names match those filters."
                : "Choose filters, then tap Find names."
            messageView.show(message: helperMessage, tintColor: ProMomColor.textSecondary)
        } else {
            messageView.hide()
        }

        tableView.reloadData()
        updateTableHeaderLayout()
    }

    private var selectedGenderIndex: Int {
        switch viewModel.state.selectedGender {
        case .girl:
            return 1
        case .boy:
            return 2
        case .unisex:
            return 3
        case nil:
            return 0
        }
    }
}

extension NameSparkViewController: NameSparkViewModelDelegate {
    func nameSparkViewModelDidUpdate(_ viewModel: NameSparkViewModel) {
        render()
    }
}

extension NameSparkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.state.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NameResultCell.reuseIdentifier,
            for: indexPath
        ) as? NameResultCell else {
            return UITableViewCell()
        }

        if let result = viewModel.result(at: indexPath) {
            cell.configure(with: result)
        }

        return cell
    }
}

extension NameSparkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let result = viewModel.result(at: indexPath) else { return }
        onSelectResult?(result)
    }
}
