//
//  ImageInfinityScroll.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 26/02/2025.
//

import SwiftUI
import Kingfisher

struct ImageInfinityScroll: View {
    enum PhotoQueue {
        case next
        case prev
        
        var image: String {
            switch self {
            case .next:
                return "arrow.right.circle"
            case .prev:
                return "arrow.left.circle"
                
            }
        }
    }
    
    @State var photoUrls: [String?] = []
    
    @State private var photoInx: Int = 0
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(photoUrls.indices, id: \.self) { index in
                    KFImage(URL(string: photoUrls[index] ?? ""))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width)
                        .offset(x: CGFloat(index - photoInx) * UIScreen.main.bounds.width + dragOffset)
                        .animation(.easeInOut(duration: 0.3), value: photoInx)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation {
                            dragOffset = value.translation.width
                        }
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width < -threshold {
                            getPhoto(queue: .next)
                        } else if value.translation.width > threshold {
                            getPhoto(queue: .prev)
                        }
                        dragOffset = 0
                    }
            )
            
            scrollPagination
                .padding(.top, 8)
        }
    }
    
//    func button(type: PhotoQueue) -> some View {
//        Image(systemName: type.image)
//            .renderingMode(.template)
//            .resizable()
//            .frame(width: 32, height: 32)
//            .foregroundStyle(Color.blueMain)
//            .onTapGesture {
//                getPhoto(queue: type)
//            }
//    }
    
    func getPhoto(queue: PhotoQueue) {
        withAnimation{
            if queue == .next {
                if photoInx == photoUrls.count - 1 {
                    photoInx = 0
                } else {
                    photoInx += 1
                }
            } else {
                if photoInx == 0 {
                    photoInx = photoUrls.count - 1
                } else {
                    photoInx -= 1
                }
                
            }
        }
    }
    
    var scrollPagination: some View {
            HStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(photoInx%4 == index ? .blue : .gray.opacity(0.5))
                        .scaleEffect(photoInx%4 == index ? 1.2 : 1.0) // Powiększenie aktywnej kropki
                        .animation(.spring(), value: photoInx)
                }
            }
        }
}

#Preview {
    ImageInfinityScroll()
}
