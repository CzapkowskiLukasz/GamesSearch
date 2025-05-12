//
//  ParentPlatformsEntity.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 15/03/2025.
//

import Foundation
import SQLite

//struct ParentPlatformWrapper: Codable, Hashable {
//    let platform: Game.ParentPlatform
//    let gameId: Int
//}

struct ParentPlatformEntity: DBEntity {
    
    typealias DataType = Game.ParentPlatform
    typealias Schema = Table
    
    static var schemaName = "parent_platforms"
    static var schema = Table(schemaName)
    
    enum Column {
        static let id = Expression<Int>("id")
        static let name = Expression<String>("name")
        static let slug = Expression<String>("slug")
    }
    
    static func create(from row: SQLite.Row) -> DataType {
        .init(
                id: row[Column.id],
                name: row[Column.name],
                slug: row[Column.slug]
        )
    }
    
    static func toSetterMap(object: DataType) -> [SQLite.Setter] {
        return [
            Column.id <- object.id,
            Column.name <- object.name,
            Column.slug <- object.slug
        ]
    }
    
    static func createSchema(db: SQLite.Connection) throws {
        try db.run(
            schema.create(
                ifNotExists: true,
                block: { builder in
                    builder.column(Column.id, primaryKey: true)
                    builder.column(Column.name)
                    builder.column(Column.slug)
                }))
    }
    
    static let repository: MainPlatformRepository = .init()
}
