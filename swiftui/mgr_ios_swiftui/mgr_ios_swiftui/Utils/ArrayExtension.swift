//
//  ArrayExtension.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 15/03/2025.
//

import Foundation

extension Array {
    
    var notEmpty: Bool {
        !isEmpty
    }
    
    func chunked(into size: Int) -> [[Element]] {
        
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
        
    }
}
