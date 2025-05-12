//
//  GamesRepository.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 15/03/2025.
//

import Foundation
import SQLite

protocol GamesRepository: DBRepository where Entity == GamesEntity {
    
    func searchGames(byName name: String, pagination: Pagination) throws -> [Entity.DataType]
    
    func getAll(pagination: Pagination) throws -> [Entity.DataType]
}
