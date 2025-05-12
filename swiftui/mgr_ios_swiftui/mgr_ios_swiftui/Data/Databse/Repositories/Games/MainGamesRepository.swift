//
//  MainGamesEntity.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 15/03/2025.
//

import Foundation
import SQLite

class MainGamesRepository: GamesRepository {
    
    func searchGames(byName name: String, pagination: Pagination) throws -> [Entity.DataType] {
        (
            try? fetch(
                by: Entity.Column.slug.like("%\(name.lowercased())%e"),
                limit: .init(limit: pagination.pageSize, offset: pagination.sqlOffset)
            )
        ) ?? []
    }
    
    func getAll(pagination: Pagination) throws -> [Entity.DataType] {
        (
            try? fetch(
                limit: .init(limit: pagination.pageSize, offset: pagination.page * pagination.pageSize)
            )
        ) ?? []
    }
}
