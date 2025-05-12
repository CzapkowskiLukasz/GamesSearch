//
//  ExpandableTextView.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 21/03/2025.
//

import SwiftUI

struct ExpandableTextView: View {
    let text: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                
                if let attributedString = htmlToAttributedString(text) {
                    Text(attributedString)
                        .lineLimit(isExpanded ? nil : 3) // Ogranicza do 3 linii, jeśli zwinięte
                        .animation(.easeInOut, value: isExpanded)
                        .padding(.bottom, 20) // Dodatkowy padding dla efektu
                        .foregroundColor(.white)
                } else {
                    Text("Błąd ładowania treści")
                        .lineLimit(isExpanded ? nil : 3) // Ogranicza do 3 linii, jeśli zwinięte
                        .animation(.easeInOut, value: isExpanded)
                        .padding(.bottom, 20) // Dodatkowy padding dla efektu
                        .foregroundColor(.white)
                }
                
                
                if !isExpanded {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            //Color.background.opacity(0.5),
                            Color.background,
                        ]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .frame(height: 50) // Wysokość zacienienia
                }
            }
            
            HStack(alignment: .center) {
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text(isExpanded ? "Zwiń opis" : "Rozwiń opis")
                            .foregroundColor(.blue)
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
            }
            .offset(y: -16)
        }
        .padding(.horizontal, 16)
        .background(Color.background)
    }
    
    func htmlToAttributedString(_ html: String) -> AttributedString? {
        guard let data = html.data(using: .utf8) else { return nil }
        
        do {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            
            let nsAttributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
            
            // Tworzymy AttributedString z NSAttributedString
            var attributedString = AttributedString(nsAttributedString)
            
            // Ustawiamy kolor tekstu na biały
            attributedString.foregroundColor = .white
            attributedString.font = .system(size: 16)
            
            return attributedString
        } catch {
            return nil
        }
    }
}

#Preview {
    ExpandableTextView(text: "To jest przykładowy tekst, który można rozwinąć lub zwinąć. Możesz dodać więcej treści, a ona będzie ukrywana, gdy komponent jest zwinięty.To jest przykładowy tekst, który można rozwinąć lub zwinąć. Możesz dodać więcej treści, a ona będzie ukrywana, gdy komponent jest zwinięty.")
}


