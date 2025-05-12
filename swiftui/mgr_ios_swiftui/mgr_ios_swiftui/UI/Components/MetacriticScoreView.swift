//
//  MetacriticScoreView.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 20/01/2025.
//

import SwiftUI

struct MetacriticScoreView: View {
    let rating: Int?
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.65)) // Tło w kształcie koła
                .frame(width: 38, height: 38) // Rozmiar koła

            Text("\(rating ?? 0)") // Tekst z oceną
                .foregroundColor(.black)
                .font(.headline)
        }
    }
    
    private var color: Color {
        switch rating ?? 0 {
        case 0...20:
            return Color.rating1
        case 21...41:
            return Color.rating2
        case 42...61:
            return Color.rating3
        case 62...81:
            return Color.rating4
        case 82...100:
            return Color.rating5
        default:
            return Color.rating1
        }
    }
}

#Preview {
    MetacriticScoreView(rating: 47)
}
