//
//  PlatformView.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 20/01/2025.
//

import SwiftUI

enum PlatformTag: Int {
    case pc = 1
    case ps5 = 2
    case macos = 5
    case nintendoSwitch = 7
    case xbox = 3
    
    var image: Image {
        return {
            switch self {
            case .pc:
                return Image("windows_logo")
            case .ps5:
                return Image("ps_logo")
            case .macos:
                return Image("mac_logo")
            case .nintendoSwitch:
                return Image("nintendo_logo")
            case .xbox:
                return Image("xbox_logo")
            }
        }()
    }
    
    var size: CGFloat {
        return {
            switch self {
            case .pc:
                return 16
            case .ps5:
                return 19
            case .macos:
                return 28
            case .nintendoSwitch:
                return 15
            case .xbox:
                return 21
            }
        }()
    }
}

struct PlatformView: View {
    let platform: PlatformTag
    
    var body: some View {
        platform.image
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .frame(height: platform.size)
            .foregroundStyle(.white)
    }
}

#Preview {
    PlatformView(platform: .ps5)
}
