//
//  PlatformsView.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 20/03/2025.
//

import SwiftUI

struct PlatformsView: View {
    let parentPlatforms: [Game.PlatformWrapper]?
    
    var body: some View {
            if let parentPlatforms = parentPlatforms {
                HStack {
                    ForEach(parentPlatforms, id: \.platform.id) { parentPlatform in
                        PlatformView(platform: .init(rawValue: parentPlatform.platform.id) ?? .ps5)
                    }
                }
            }
    }
}

//#Preview {
//    PlatformsView()
//}
