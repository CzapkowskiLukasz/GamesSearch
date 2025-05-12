//
//  PlatformTagView.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 20/01/2025.
//

import SwiftUI

struct PlatformTagView: View {
    let name: String
    
    var body: some View {
        HStack {
            Text(name)
        }
        .cornerRadius(10)
    }
}

#Preview {
    PlatformTagView(name: "PC")
}
