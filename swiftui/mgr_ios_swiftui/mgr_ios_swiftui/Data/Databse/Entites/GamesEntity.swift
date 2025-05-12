//
//  GamesEntity.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 15/03/2025.
//

import Foundation
import SQLite

public typealias Expression = SQLite.Expression

struct GamesEntity: DBEntity {
    
    typealias DataType = Game
    typealias Schema = Table
    
    static var schemaName = "games"
    static var schema = Table(schemaName)
    
    enum Column {
        static let id = Expression<Int>("id")
        static let slug = Expression<String>("slug")
        static let name = Expression<String>("name")
        static let released = Expression<String?>("released")
        static let tba = Expression<Bool>("tba")
        static let backgroundImage = Expression<String?>("background_image")
        static let rating = Expression<Double>("rating")
        static let ratingTop = Expression<Int>("rating_top")
        static let ratingsCount = Expression<Int>("ratings_count")
        static let reviewsTextCount = Expression<Int>("reviews_text_count")
        static let added = Expression<Int>("added")
        static let metacritic = Expression<Int?>("metacritic")
        static let playtime = Expression<Int>("playtime")
        static let suggestionsCount = Expression<Int>("suggestions_count")
        static let updated = Expression<String>("updated")
    }
    
    static func create(from row: SQLite.Row) -> DataType {
        .init(
            id: row[Column.id],
            slug: row[Column.slug],
            name: row[Column.name],
            released: row[Column.released],
            tba: row[Column.tba],
            backgroundImage: row[Column.backgroundImage],
            rating: row[Column.rating],
            ratingTop: row[Column.ratingTop],
            ratings: [],
            ratingsCount: row[Column.ratingsCount],
            reviewsTextCount: row[Column.reviewsTextCount],
            added: row[Column.added],
            addedByStatus: nil,
            metacritic: row[Column.metacritic],
            playtime: row[Column.playtime],
            suggestionsCount: row[Column.suggestionsCount],
            updated: row[Column.updated],
            esrbRating: nil,
            platforms: nil,
            parentPlatforms: [],//(try? ParentPlatformEntity.repository.getByGameId(gameId: row[Column.id]) ?? []),
            genres: [],
            tags: [],
            shortScreenshots: []
        )
    }
    
    static func toSetterMap(object: DataType) -> [SQLite.Setter] {
        return [
            Column.id <- object.id,
            Column.slug <- object.slug,
            Column.name <- object.name,
            Column.released <- object.released,
            Column.tba <- object.tba,
            Column.backgroundImage <- object.backgroundImage,
            Column.rating <- object.rating,
            Column.ratingTop <- object.ratingTop,
            Column.ratingsCount <- object.ratingsCount,
            Column.reviewsTextCount <- object.reviewsTextCount,
            Column.added <- object.added,
            Column.metacritic <- object.metacritic,
            Column.playtime <- object.playtime,
            Column.suggestionsCount <- object.suggestionsCount,
            Column.updated <- object.updated
        ]
    }
    
    static func createSchema(db: SQLite.Connection) throws {
        try db.run(
            schema.create(
                ifNotExists: true,
                block: { builder in
                    builder.column(Column.id, primaryKey: true)
                    builder.column(Column.slug)
                    builder.column(Column.name)
                    builder.column(Column.released)
                    builder.column(Column.tba)
                    builder.column(Column.backgroundImage)
                    builder.column(Column.rating)
                    builder.column(Column.ratingTop)
                    builder.column(Column.ratingsCount)
                    builder.column(Column.reviewsTextCount)
                    builder.column(Column.added)
                    builder.column(Column.metacritic)
                    builder.column(Column.playtime)
                    builder.column(Column.suggestionsCount)
                    builder.column(Column.updated)
                }))
    }
    
    static let repository: MainGamesRepository = .init()
}
