//
//  Pagination.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 22/01/2025.
//

import Foundation

struct Pagination {
    
    let pageSize: Int
    var page: Int = 1
    
    init(pageSize: Int = 50) {
        self.pageSize = pageSize
    }
    
    mutating func increasePage() {
        page += 1
    }
    
    var sqlOffset: Int {
        return (page - 1) * pageSize
    }
    
}
