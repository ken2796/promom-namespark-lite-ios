import Foundation

enum NameGender: String, CaseIterable, Codable {
    case girl
    case boy
    case unisex

    var displayTitle: String {
        switch self {
        case .girl:
            return "Girl"
        case .boy:
            return "Boy"
        case .unisex:
            return "Unisex"
        }
    }
}

enum NameOrigin: String, CaseIterable, Codable {
    case arabic
    case hebrew
    case latin
    case japanese

    var displayTitle: String {
        rawValue.capitalized
    }
}

struct NameSparkSearchRequest: Encodable {
    let gender: NameGender?
    let origins: [NameOrigin]
    let startingLetter: String?
    let limit: Int?
}

struct NameSearchResult: Codable, Hashable {
    let id: String
    let name: String
    let meaning: String
    let gender: NameGender
    let origin: NameOrigin
    let matchScore: Int
    var isFavorite: Bool

    var metadataLine: String {
        "\(origin.displayTitle) • \(gender.displayTitle)"
    }
}

struct NameDetail: Codable, Hashable {
    let id: String
    let name: String
    let meaning: String
    let gender: NameGender
    let origin: NameOrigin
    let styles: [String]
    let popularity: String
    let insight: String
    let isFavorite: Bool

    var stylesLine: String {
        styles.joined(separator: ", ")
    }
}
