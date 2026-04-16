import Foundation

enum HTTPClientError: LocalizedError {
    case invalidResponse
    case requestFailed(underlying: Error)
    case invalidStatusCode(Int)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server response was invalid."
        case let .requestFailed(underlying):
            return underlying.localizedDescription
        case let .invalidStatusCode(code):
            return "The server returned status code \(code)."
        }
    }
}

protocol HTTPClient {
    func send<T: Decodable>(_ request: URLRequest, decodeTo: T.Type) async throws -> T
}

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    func send<T: Decodable>(_ request: URLRequest, decodeTo: T.Type) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw HTTPClientError.invalidResponse
            }

            guard 200..<300 ~= httpResponse.statusCode else {
                throw HTTPClientError.invalidStatusCode(httpResponse.statusCode)
            }

            return try decoder.decode(T.self, from: data)
        } catch let error as HTTPClientError {
            throw error
        } catch {
            throw HTTPClientError.requestFailed(underlying: error)
        }
    }
}
