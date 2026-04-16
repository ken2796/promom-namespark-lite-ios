import Foundation

struct AppEnvironment {
    let apiBaseURL: URL
    let apiClient: NameSparkAPIClientProtocol

    static func makeDefault() -> AppEnvironment {
        let baseURL = URL(string: "http://localhost:3000")!
        let httpClient = URLSessionHTTPClient()
        let apiClient = NameSparkAPIClient(baseURL: baseURL, httpClient: httpClient)

        return AppEnvironment(
            apiBaseURL: baseURL,
            apiClient: apiClient
        )
    }
}
