import UIKit

@MainActor
final class AppCoordinator {
    private let navigationController: UINavigationController
    private let environment: AppEnvironment
    private weak var searchViewModel: NameSparkViewModel?

    init(navigationController: UINavigationController, environment: AppEnvironment) {
        self.navigationController = navigationController
        self.environment = environment
    }

    func start() {
        let viewModel = NameSparkViewModel(apiClient: environment.apiClient)
        searchViewModel = viewModel
        let viewController = NameSparkViewController(viewModel: viewModel)

        viewController.onSelectResult = { [weak self] result in
            self?.showDetail(for: result)
        }

        navigationController.setViewControllers([viewController], animated: false)
    }

    private func showDetail(for result: NameSearchResult) {
        let viewModel = NameDetailViewModel(
            nameID: result.id,
            seedName: result.name,
            apiClient: environment.apiClient
        )

        viewModel.onFavoriteUpdated = { [weak self] updated in
            self?.searchViewModel?.updateFavorite(for: updated.id, isFavorite: updated.isFavorite)
        }

        let viewController = NameDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
