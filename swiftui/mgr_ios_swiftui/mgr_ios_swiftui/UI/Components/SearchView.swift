//
//  SearchView.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 20/01/2025.
//

import SwiftUI

struct SearchView: View {
    
    @MainActor var search: Binding<String>
    
    var body: some View {
        
        // Search bar
        HStack {
            TextField("", text: search)
                .textFieldStyle(
                    CustomTextFieldStyle(
                        text: search,
                        placeholder: "Wpisz frazę..."
                    )
                )
        }
        .padding([.top, .horizontal], 16)
        .background(Color.cellBackground)
    }
}

#Preview {
    SearchView(search: .constant(""))
}
