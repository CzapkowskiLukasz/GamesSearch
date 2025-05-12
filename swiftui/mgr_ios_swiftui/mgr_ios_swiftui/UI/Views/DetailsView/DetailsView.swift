//
//  DetailsView.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 02/02/2025.
//

import SwiftUI
import Kingfisher

struct DetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: DetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ImageInfinityScroll(photoUrls: viewModel.photoUrls)
                
                VStack(spacing: 16) {
                    // Nazwa gry
                    Text(viewModel.game.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Data wydania
                    if let released = viewModel.game.released {
                        Text("Data wydania: \(released)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                    }
                    
                    // Oceny
                    RatingView(rating: viewModel.game.rating, metacritic: viewModel.game.metacritic)
                    
                    // Platformy
                    if let platforms = viewModel.game.parentPlatforms?.compactMap({ $0.platform.name }) {
                        PlatformsView(parentPlatforms: viewModel.game.parentPlatforms)
                    }
                    
                    // Description
                    if let description = viewModel.details?.description, !description.isEmpty {
                        ExpandableTextView(text: description)
                    }
                    
                    // Game Status
                    GameStatusBars(viewModel: viewModel)
                    
                    // Link to website
                    WebsiteLinkView(website: viewModel.details?.website)
                    
                }
            }
            .padding(.horizontal, 16)
            .background(Color.background)
        }
        .foregroundColor(.white)
        .background(Color.background)
        .navigationBarBackButtonHidden(true) // Hide default back button
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .renderingMode(.template)
                                    
                                Text("Wróć") // Custom label
                            }
                            .foregroundColor(Color.blueMain)
                        }
                    }
                }
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    private var color: Color {
        switch viewModel.game.metacritic ?? 0 {
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
    
    @ViewBuilder
    func statusBar(title: String, value: Int?) -> some View {
        if let value = value {
            StatusBarView(title: title, value: value, maxValue: viewModel.getMaxValue())
        }
    }
}

struct RatingView: View {
    let rating: Double
    let metacritic: Int?
    
    var body: some View {
        HStack {
            Text("⭐ \(String(format: "%.1f", rating)) / 5.0")
                .font(.headline)
            
            if let metacritic = metacritic {
                Text("Metacritic: \(metacritic)")
                    .font(.headline)
                    .foregroundColor(metacriticColor(for: metacritic))
            }
        }
        .padding(.horizontal)
    }
    
    private func metacriticColor(for score: Int) -> Color {
        switch score {
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

struct GameStatusBars: View {
    @ObservedObject var viewModel: DetailsViewModel
    
    var body: some View {
        Group {
            statusBar(title: "Posiadane", value: viewModel.game.addedByStatus?.owned)
            statusBar(title: "Ukończone", value: viewModel.game.addedByStatus?.beaten)
            statusBar(title: "Grane", value: viewModel.game.addedByStatus?.playing)
            statusBar(title: "Ulubione", value: viewModel.game.addedByStatus?.toplay)
            statusBar(title: "Porzucone", value: viewModel.game.addedByStatus?.dropped)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func statusBar(title: String, value: Int?) -> some View {
        if let value = value {
            StatusBarView(title: title, value: value, maxValue: viewModel.getMaxValue())
        }
    }
}

struct WebsiteLinkView: View {
    let website: String?
    
    var body: some View {
        if let website = website, let url = URL(string: website) {
            HStack(spacing: 2) {
                
                Spacer()
                
                Text ("🌐:")
                Link(website, destination: url)
                    .underline()
                    .foregroundColor(.white)
                
            }
            .font(.caption)
        }
    }
}
