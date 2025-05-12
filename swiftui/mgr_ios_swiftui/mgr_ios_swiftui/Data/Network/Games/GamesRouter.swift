//
//  GamesRouter.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 19/01/2025.
//

import Foundation

struct GamesRouter: ApiRouterProtocol {
    
    func invoke() {
        
    }
    
    func getGames(search: String, pagination: Pagination) async throws -> GamesResponse {
        return try await manager.performRequest(
            url: baseUrl + "games",
            method: .get,
            query: [
                .init(name: "search", value: search),
                .init(name: "page", value: "\(pagination.page)"),
                .init(name: "pageSize", value: "\(pagination.pageSize)")
            ]
        )
    }
    
    func gameDetails(gameId: String) async throws -> GameDetails {
        return try await manager.performRequest(
            url: baseUrl + "games/\(gameId)",
            method: .get
        )
    }
}
