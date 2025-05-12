//
//  Game.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 19/01/2025.
//

import Foundation

struct GamesResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Game]
}

struct Game: Codable, Identifiable, Hashable {
    let id: Int
    let slug: String
    let name: String
    let released: String?
    let tba: Bool
    let backgroundImage: String?
    let rating: Double
    let ratingTop: Int
    let ratings: [Rating]
    let ratingsCount: Int
    let reviewsTextCount: Int
    let added: Int
    let addedByStatus: AddedByStatus?
    let metacritic: Int?
    let playtime: Int
    let suggestionsCount: Int
    let updated: String
    let esrbRating: ESRBRating?
    let platforms: [Platform]?
    let parentPlatforms: [PlatformWrapper]?
    let genres: [Genre]
    let tags: [Tags]
    let shortScreenshots: [Screenshot]

    // Mapowanie kluczy JSON na właściwości w Swift
    enum CodingKeys: String, CodingKey {
        case id, slug, name, released, tba, rating
        case backgroundImage = "background_image"
        case ratingTop = "rating_top"
        case ratings
        case ratingsCount = "ratings_count"
        case reviewsTextCount = "reviews_text_count"
        case added
        case addedByStatus = "added_by_status"
        case metacritic, playtime
        case suggestionsCount = "suggestions_count"
        case updated
        case esrbRating = "esrb_rating"
        case platforms
        case genres
        case tags
        case shortScreenshots = "short_screenshots"
        case parentPlatforms = "parent_platforms"
    }
    
    struct Rating: Codable, Hashable {
        let id: Int
        let title: String
        let count: Int
        let percent: Double
    }
    
    struct Platform: Codable, Hashable {
        let platform: PlatformDetails
        let releasedAt: String?
        let requirementsEn: Requirements?
        let requirementsRu: Requirements?

        enum CodingKeys: String, CodingKey {
            case platform
            case releasedAt = "released_at"
            case requirementsEn = "requirements_en"
            case requirementsRu = "requirements_ru"
        }
    }

    struct PlatformDetails: Codable, Hashable {
        let id: Int
        let name: String
        let slug: String
        let image: String?
        let yearEnd: Int?
        let yearStart: Int?
        let gamesCount: Int?
        let imageBackground: String?

        enum CodingKeys: String, CodingKey {
            case id, name, slug, image
            case yearEnd = "year_end"
            case yearStart = "year_start"
            case gamesCount = "games_count"
            case imageBackground = "image_background"
        }
    }
    
    struct AddedByStatus: Codable, Hashable {
        let yet: Int?
        let owned: Int?
        let beaten: Int?
        let toplay: Int?
        let dropped: Int?
        let playing: Int?
    }

    struct Requirements: Codable, Hashable {
        let minimum: String?
        let recommended: String?
    }
    
    struct ESRBRating: Codable, Hashable {
        let id: Int
        let name: String
        let slug: String
    }
    
    struct Genre: Codable, Hashable {
        let id: Int
        let name: String
        let slug: String
        let gamesCount: Int?
        let imageBackground: String?

        enum CodingKeys: String, CodingKey {
            case id, name, slug
            case gamesCount = "games_count"
            case imageBackground = "image_background"
        }
    }
    
    struct Tags: Codable, Hashable {
        let id: Int
        let name: String
        let slug: String
        let language: String
        let gamesCount: Int?
        let imageBackground: String?

        enum CodingKeys: String, CodingKey {
            case id, name, slug, language
            case gamesCount = "games_count"
            case imageBackground = "image_background"
        }
    }
    
    struct PlatformWrapper: Codable, Hashable {
        let platform: ParentPlatform
    }
    
    struct ParentPlatform: Codable, Identifiable, Hashable {
        let id: Int
        let name: String
        let slug: String
    }

    // Struktura dla zrzutu ekranu
    struct Screenshot: Codable, Hashable {
        let id: Int
        let image: String
    }
}
