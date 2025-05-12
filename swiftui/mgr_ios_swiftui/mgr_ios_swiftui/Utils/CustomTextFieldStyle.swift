//
//  TextFieldStyle.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 21/01/2025.
//

import SwiftUI

import Speech

struct CustomTextFieldStyle: TextFieldStyle {
    
    @FocusState private var isFocused: Bool
    @Binding var text: String
    @State private var showPlaceholder: Bool = true
    @State private var isListening = false
    @State private var speechRecognizer = SpeechRecognizer()
    
    var placeholder: String
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            configuration
                .padding(.leading, 12)
                .padding(.vertical, 8)
                .foregroundColor(.white.opacity(0.9))
                .font(.caption2)
                .accentColor(.white.opacity(0.8))
                .focused($isFocused)
                .onChange(of: text) { newValue in
                    withAnimation {
                        showPlaceholder = newValue.isEmpty
                    }
                }
                .onChange(of: isFocused) { newValue in
                    withAnimation {
                        showPlaceholder = text.isEmpty
                    }
                }
            
            // Przycisk mikrofonu do dyktowania
            Button(action: {
                isListening.toggle()
                if isListening {
                    speechRecognizer.startRecording { result in
                        text = result
                    }
                } else {
                    speechRecognizer.stopRecording()
                }
            }) {
                Image(systemName: isListening ? "mic.fill" : "mic")
                    .foregroundColor(.blueMain)
                    .padding(.trailing, 12)
            }
        }
        .background(Color.background)
        .cornerRadius(50)
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(isFocused ? Color.blueMain : Color.clear, lineWidth: 3)
        )
        .placeholder(when: $showPlaceholder, placeholder: placeholder)
    }
}

// MARK: - Placeholder Extension
extension View {
    func placeholder(
        when shouldShow: Binding<Bool>,
        alignment: Alignment = .leading,
        placeholder: String
    ) -> some View {
        ZStack(alignment: alignment) {
            self
            if shouldShow.wrappedValue {
                Text(placeholder)
                    .padding(.leading, 12)
                    .foregroundStyle(.white.opacity(0.9))
                    .font(.caption2)
            }
        }
    }
}
