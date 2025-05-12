//
//  SwitchView.swift
//  eurocash360

//

import SwiftUI

struct SwitchView: View {
    
    struct SideSettings {
        
        let title: String
        
        let color: Color
        
    }
    
    @Namespace private var namespace
    @Binding var activeTab: Int
    let settings: [SideSettings]
    var backgroundColor: Color = .clear
    var borderColor: Color = .clear
    var buttonPadding: CGFloat = 4
    
    private(set) var activeColor: Color = .white
    
    private(set) var inactiveColor: Color = .white
    
    var canSwitch: (_ tab: Int) -> Bool = { _ in return true }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            ForEach(Array(settings.enumerated()), id: \.offset) { (index, setting) in
            
                button(
                    title: setting.title,
                    index: index,
                    activeBackgroundColor: setting.color
                )
                 
                if index != settings.count-1 && activeTab != index && activeTab != index+1 {
                    Rectangle()
                    .fill(Color.cellBackground)
                    .frame(width: 1, height: 16)
                }
               
            }
        }
        .padding(4)
        .background(Color.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: .infinity))
        .overlay {
            RoundedRectangle(cornerRadius: .infinity)
                .stroke(borderColor, lineWidth: 1)
        }
        
    }
    
    private func button(
        title: String,
        index: Int,
        activeBackgroundColor: Color
    ) -> some View {

        ZStack {
            
        let isActive: Bool = activeTab == index

            if isActive {
                RoundedRectangle(cornerRadius: .infinity)
                    .matchedGeometryEffect(id: "active_background", in: namespace)
                    .foregroundColor(activeBackgroundColor)

            }
            
            Text(title)
                .foregroundColor(isActive ? activeColor : inactiveColor.opacity(0.5))
                .font(.caption)
                .fixedSize()
                .frame(maxWidth: .infinity)
                .padding(buttonPadding)
                .layoutPriority(1)
                .onTapGesture {
                    if canSwitch(index) {
                        withAnimation(.spring()) {
                            activeTab = index
                        }
                    }
                }
        }
    }
    
}
//
//struct SwitchView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        Preview()
//    }
//    
//    struct Preview: View {
//        
//        @State var activeTab: Int = 0
//        
//        var body: some View {
//            
//            SwitchView(
//                activeTab: $activeTab,
//                settings: [
//                    .init(title: "Historia", color: .green),
//                    .init(title: "Do zatwierdzenia", color: .green),
//                    .init(title: "Zapisane", color: .green)
//                ]
//            )
//            .padding(16)
//            
//        }
//        
//    }
//    
//}
