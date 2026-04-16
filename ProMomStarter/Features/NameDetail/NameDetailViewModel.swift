import Foundation

@MainActor
protocol NameDetailViewModelDelegate: AnyObject {
    func nameDetailViewModelDidUpdate(_ viewModel: NameDetailViewModel)
}

@MainActor
final class NameDetailViewModel {
    struct State {
        var isLoading = false
        var isSaving = false
        var detail: NameDetail?
        var errorMessage: String?
    }

    weak var delegate: NameDetailViewModelDelegate?
    var onFavoriteUpdated: ((NameDetail) -> Void)?
    private(set) var state = State()

    let seedName: String

    private let nameID: String
    private let apiClient: NameSparkAPIClientProtocol

    init(nameID: String, seedName: String, apiClient: NameSparkAPIClientProtocol) {
        self.nameID = nameID
        self.seedName = seedName
        self.apiClient = apiClient
    }

    func viewDidLoad() {
        Task {
            await loadDetail()
        }
    }

    func toggleFavorite() {
        guard let detail = state.detail else {
            state.errorMessage = "Load the name detail before saving."
            delegate?.nameDetailViewModelDidUpdate(self)
            return
        }

        Task {
            state.isSaving = true
            state.errorMessage = nil
            delegate?.nameDetailViewModelDidUpdate(self)

            do {
                let updated = try await apiClient.updateFavorite(id: nameID, isFavorite: !detail.isFavorite)
                state.detail = updated
                onFavoriteUpdated?(updated)
            } catch {
                state.errorMessage = "Couldn't update favorite. Please try again."
            }

            state.isSaving = false
            delegate?.nameDetailViewModelDidUpdate(self)
        }
    }

    private func loadDetail() async {
        state.isLoading = true
        state.errorMessage = nil
        delegate?.nameDetailViewModelDidUpdate(self)

        do {
            let detail = try await apiClient.fetchDetail(id: nameID)
            state.detail = detail
        } catch {
            state.errorMessage = "Couldn't load name details. Please go back and try again."
        }

        state.isLoading = false
        delegate?.nameDetailViewModelDidUpdate(self)
    }
}
