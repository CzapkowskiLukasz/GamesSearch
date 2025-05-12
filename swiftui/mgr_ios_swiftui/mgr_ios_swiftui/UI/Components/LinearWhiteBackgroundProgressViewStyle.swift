//
//  LinearWhiteBackgroundProgressView.swift
//  eurocash360
//
//  Created by Łukasz Czapkowski on 16/11/2023.
//

import SwiftUI

struct LinearWhiteBackgroundProgressViewStyle: ProgressViewStyle {
    var backgroundColor: Color
    var mainColor: Color
    var strokeColor: Color?
    var inset: Double?
    var width: Double?
    @State var size: CGSize = .zero

    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 5)
                .fill(backgroundColor)
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                size = proxy.size
                            }
                    }
                )
                .frame(height: 8)
            
            RoundedRectangle(cornerRadius: 100)
                .inset(by: getInset())
                .stroke(getColor())
                .frame(height: 8)
            
            RoundedRectangle(cornerRadius: 5)
                .fill(mainColor)
                .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * getWidth(), height: 8)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func getColor() -> Color {
        if let strokeColor = strokeColor {
            return strokeColor
        } else {
            return mainColor
        }
    }
    
    private func getInset() -> Double {
        if let inset = inset {
            return inset
        } else {
            return 1
        }
    }
    
    private func getWidth() -> Double {
        if let width = width {
            return width
        } else {
            return size.width
        }
    }
}

