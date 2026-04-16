import Foundation

protocol NameSparkAPIClientProtocol {
    func search(request: NameSparkSearchRequest) async throws -> [NameSearchResult]
    func fetchDetail(id: String) async throws -> NameDetail
    func updateFavorite(id: String, isFavorite: Bool) async throws -> NameDetail
}

final class NameSparkAPIClient: NameSparkAPIClientProtocol {
    private let baseURL: URL
    private let httpClient: HTTPClient
    private let encoder: JSONEncoder

    init(baseURL: URL, httpClient: HTTPClient) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.encoder = JSONEncoder()
    }

    func search(request: NameSparkSearchRequest) async throws -> [NameSearchResult] {
        var urlRequest = URLRequest(url: baseURL.appending(path: "/v1/name-spark/search"))
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try encoder.encode(request)

        return try await httpClient.send(urlRequest, decodeTo: [NameSearchResult].self)
    }

    func fetchDetail(id: String) async throws -> NameDetail {
        var urlRequest = URLRequest(url: baseURL.appending(path: "/v1/names/\(id)"))
        urlRequest.httpMethod = "GET"

        return try await httpClient.send(urlRequest, decodeTo: NameDetail.self)
    }

    func updateFavorite(id: String, isFavorite: Bool) async throws -> NameDetail {
        var urlRequest = URLRequest(url: baseURL.appending(path: "/v1/names/\(id)/favorite"))
        urlRequest.httpMethod = "PATCH"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try encoder.encode(FavoriteUpdateRequest(isFavorite: isFavorite))

        return try await httpClient.send(urlRequest, decodeTo: NameDetail.self)
    }
}

private struct FavoriteUpdateRequest: Encodable {
    let isFavorite: Bool
}
