//
//  ParentPlatform.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 15/03/2025.
//

import Foundation

struct ParentPlatformResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Game.ParentPlatform]
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
    }
}
