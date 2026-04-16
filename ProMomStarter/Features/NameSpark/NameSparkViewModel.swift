import Foundation

@MainActor
protocol NameSparkViewModelDelegate: AnyObject {
    func nameSparkViewModelDidUpdate(_ viewModel: NameSparkViewModel)
}

@MainActor
final class NameSparkViewModel {
    struct State {
        var selectedGender: NameGender?
        var selectedOrigins: Set<NameOrigin> = []
        var startingLetter = ""
        var isLoading = false
        var hasPerformedSearch = false
        var results: [NameSearchResult] = []
        var errorMessage: String?
        var startingLetterWarning: String?
    }

    weak var delegate: NameSparkViewModelDelegate?
    private(set) var state = State()

    private let apiClient: NameSparkAPIClientProtocol
    private var searchTask: Task<Void, Never>?

    init(apiClient: NameSparkAPIClientProtocol) {
        self.apiClient = apiClient
    }

    func viewDidLoad() {
        delegate?.nameSparkViewModelDidUpdate(self)
    }

    var isFindButtonEnabled: Bool {
        state.selectedGender != nil || !state.selectedOrigins.isEmpty || !state.startingLetter.isEmpty
    }

    func setGender(at index: Int) {
        switch index {
        case 1:
            state.selectedGender = .girl
        case 2:
            state.selectedGender = .boy
        case 3:
            state.selectedGender = .unisex
        default:
            state.selectedGender = nil
        }

        delegate?.nameSparkViewModelDidUpdate(self)
    }

    func toggleOrigin(_ origin: NameOrigin) {
        if state.selectedOrigins.contains(origin) {
            state.selectedOrigins.remove(origin)
        } else {
            state.selectedOrigins.insert(origin)
        }

        delegate?.nameSparkViewModelDidUpdate(self)
    }

    func updateStartingLetter(_ rawValue: String) {
        let trimmed = rawValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
            .prefix(1)
            .description

        if let first = trimmed.first, first.isNumber {
            // Reject the digit — keep the field empty and warn the user.
            state.startingLetter = ""
            state.startingLetterWarning = "Starting letter must be a letter, not a number."
        } else {
            state.startingLetter = trimmed
            state.startingLetterWarning = nil
        }

        delegate?.nameSparkViewModelDidUpdate(self)
    }

    func result(at indexPath: IndexPath) -> NameSearchResult? {
        guard state.results.indices.contains(indexPath.row) else { return nil }
        return state.results[indexPath.row]
    }

    /// Propagates a favorite change from the detail screen back into the results list.
    func updateFavorite(for id: String, isFavorite: Bool) {
        guard let index = state.results.firstIndex(where: { $0.id == id }) else { return }
        state.results[index].isFavorite = isFavorite
        delegate?.nameSparkViewModelDidUpdate(self)
    }

    func findNames() {
        // Cancel any in-flight search so results never arrive out of order.
        searchTask?.cancel()

        let request = NameSparkSearchRequest(
            gender: state.selectedGender,
            origins: Array(state.selectedOrigins),
            startingLetter: state.startingLetter.isEmpty ? nil : state.startingLetter,
            limit: nil
        )

        state.isLoading = true
        state.hasPerformedSearch = true
        state.errorMessage = nil
        delegate?.nameSparkViewModelDidUpdate(self)

        searchTask = Task {
            do {
                let results = try await apiClient.search(request: request)
                guard !Task.isCancelled else { return }
                state.results = results
                state.errorMessage = nil
            } catch {
                guard !Task.isCancelled else { return }
                state.results = []
                state.errorMessage = "Something went wrong. Please try again."
            }
            state.isLoading = false
            delegate?.nameSparkViewModelDidUpdate(self)
        }
    }
}
