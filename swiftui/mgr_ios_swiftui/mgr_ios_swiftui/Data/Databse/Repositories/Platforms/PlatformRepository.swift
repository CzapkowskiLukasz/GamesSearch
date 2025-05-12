//
//  PlatformRepository.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 15/03/2025.
//

import Foundation
import SQLite

protocol PlatformRepository: DBRepository where Entity == ParentPlatformEntity {
    
    //func getByGameId(gameId: Int) throws -> [Game.PlatformWrapper]?
}
