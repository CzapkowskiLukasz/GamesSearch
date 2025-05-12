//
//  PlatformGameEntity.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 15/03/2025.
//

import Foundation
import SQLite

struct ParentPlatformGame: Codable, Hashable {
    let platformId: Int
    let gameId: Int
}

struct PlatformGameEntity: DBEntity {
    
    typealias DataType = ParentPlatformGame
    typealias Schema = Table
    
    static var schemaName = "platform_game"
    static var schema = Table(schemaName)
    
    enum Column {
        static let platformId = Expression<Int>("platformId")
        static let gameId = Expression<Int>("gameId")
    }
    
    static func create(from row: SQLite.Row) -> DataType {
        .init(
            platformId: row[Column.platformId],
            gameId: row[Column.gameId]
        )
    }
    
    static func toSetterMap(object: DataType) -> [SQLite.Setter] {
        return [
            Column.platformId <- object.platformId,
            Column.gameId <- object.gameId
        ]
    }
    
    static func createSchema(db: SQLite.Connection) throws {
        try db.run(
            schema.create(
                ifNotExists: true,
                block: { builder in
                    builder.column(Column.platformId)
                    builder.column(Column.gameId)
                }))
    }
    
    static let repository: MainPlatformGameRepository = .init()
}
