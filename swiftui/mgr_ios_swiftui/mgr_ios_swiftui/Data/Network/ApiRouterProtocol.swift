//
//  ApiServiceProtocol.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 19/01/2025.
//

import Foundation

protocol ApiRouterProtocol{
    var manager: APIManager { get }
    var baseUrl: String { get }
    
    func invoke()
}

extension ApiRouterProtocol {
    var manager: APIManager {
        APIManager.shared
    }
    
    var baseUrl: String {
        "https://api.rawg.io/api/"
    }
}
