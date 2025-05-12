//
//  StatusBarView.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 19/03/2025.
//

import SwiftUI

struct StatusBarView: View {
    let title: String
    let value: Int
    let maxValue: Int
    
    @State private var animatedValue: Float = 0
    
    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .frame(width: 80, alignment: .leading)
                
            HStack {
                
                ProgressView(
                    value: animatedValue,
                    total: Float(maxValue)
                ).progressViewStyle(
                    LinearWhiteBackgroundProgressViewStyle(
                        backgroundColor: Color.background,
                        mainColor: Color.blueMain,
                        strokeColor: Color.background,
                        inset: 0.5
                    )
                )
                .padding(.trailing, 8)
                
                Text(.init("**\(value)** użytkowników"))
                    .font(.subheadline)

            }
        }
        .foregroundColor(.white)
        .onReceive(timer) { _ in
              if animatedValue < Float(value) {
                  withAnimation(.easeOut) {
                      animatedValue += Float(value)/2
                  }
              }
            }
    }
}

//#Preview {
//    StatusBarView()
//}
