//
//  PlatformRouter.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 15/03/2025.
//

import Foundation

struct PlatformRouter: ApiRouterProtocol {
    
    func invoke() {
        
    }
    
    func getPlatform() async throws -> ParentPlatformResponse {
        return try await manager.performRequest(
            url: baseUrl + "platforms/lists/parents",
            method: .get
        )
    }
}
