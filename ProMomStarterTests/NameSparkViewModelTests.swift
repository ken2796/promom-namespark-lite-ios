import XCTest
@testable import ProMomStarter

@MainActor
final class NameSparkViewModelTests: XCTestCase {
    func testUpdateStartingLetterKeepsSingleUppercaseCharacter() {
        let viewModel = NameSparkViewModel(apiClient: MockNameSparkAPIClient())

        viewModel.updateStartingLetter("mila")

        XCTAssertEqual(viewModel.state.startingLetter, "M")
    }

    func testToggleOriginAddsAndRemovesSelection() {
        let viewModel = NameSparkViewModel(apiClient: MockNameSparkAPIClient())

        viewModel.toggleOrigin(.arabic)
        XCTAssertEqual(viewModel.state.selectedOrigins, [.arabic])

        viewModel.toggleOrigin(.arabic)
        XCTAssertTrue(viewModel.state.selectedOrigins.isEmpty)
    }
}

private final class MockNameSparkAPIClient: NameSparkAPIClientProtocol {
    func search(request: NameSparkSearchRequest) async throws -> [NameSearchResult] {
        []
    }

    func fetchDetail(id: String) async throws -> NameDetail {
        fatalError("Not needed for this test")
    }

    func updateFavorite(id: String, isFavorite: Bool) async throws -> NameDetail {
        fatalError("Not needed for this test")
    }
}
