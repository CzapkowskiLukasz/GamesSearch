//
//  ListView.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 02/01/2025.
//

import SwiftUI

enum ViewType: String, CaseIterable {
    case scrollView = "ScrollView"
    case list = "List"
    case vStack = "VStack"
}

@MainActor
struct ListView: View {
    
    @StateObject var viewModel: ListViewModel = .init()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if !viewModel.games.isEmpty {
                    SwitchView(activeTab: $viewModel.selectedViewInx, settings: [
                        .init(
                            title: "List",
                            color: Color.blueMain
                        ),
                        .init(
                            title: "LazyVStack",
                            color: Color.blueMain
                        ),
                        .init(
                            title: "VStack",
                            color: Color.blueMain
                        )
                    ])
                    .padding()
                    
                    Group {
                        switch viewModel.selectedView {
                        case .scrollView:
                            ScrollViewReader { proxy in
                                ScrollView(showsIndicators: false) {
                                    LazyVStack(spacing: 16) {
                                        ForEach(viewModel.games) { game in
                                            ListCellView(viewModel: .init(game: game))
                                                .onAppear {
                                                    if game.id == viewModel.games.first?.id {
                                                        viewModel.stopTime()
                                                    }
                                                    
                                                    viewModel.check(game: game)
                                                }
                                        }
                                    }
                                    .id("TOP")
                                }
                                .onAppear {
                                    viewModel.proxy = proxy
                                }
                                .padding(.horizontal, 16)
                                .background(Color.background)
                            }
                            
                        case .list:
                            List(viewModel.games) { game in
                                ListCellView(viewModel: .init(game: game))
                                    .background(Color.background)
                                    .onAppear {
                                        if game.id == viewModel.games.first?.id {
                                            viewModel.stopTime()
                                        }
                                        
                                        viewModel.check(game: game)
                                    }
                                    .listRowBackground(Color.background)
                            }
                            .background(Color.background)
                            .listStyle(.plain)
                            .background(Color.background)
                            
                        case .vStack:
                            ScrollViewReader { proxy in
                                ScrollView(showsIndicators: false) {
                                    VStack(spacing: 16) {
                                        ForEach(viewModel.games) { game in
                                            ListCellView(viewModel: .init(game: game))
                                                .onAppear {
                                                    if game.id == viewModel.games.first?.id {
                                                        viewModel.stopTime()
                                                    }
                                                    
                                                    //viewModel.check(game: game)
                                                }
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                    }
                    .overlay(alignment: .bottom) {
                        VStack(spacing: 0) {
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    //Color.background.opacity(0.5),
                                    Color.background,
                                ]),
                                startPoint: .center,
                                endPoint: .bottom
                            )
                            .frame(height: 40)
                            SearchView(search: $viewModel.search)
                        }
                    }
                    
                    
                } else if !viewModel.isLoading {
                    Button(action: {
                        viewModel.fetchGames()
                    }) {
                        Text("Spróbuj ponownie")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    ZStack {
                        Color.background // Przyciemnione tło
                            .ignoresSafeArea() // Rozszerzenie na cały ekran
                        
                        ProgressView("Ładowanie danych")
                            .tint(Color.blueMain)
                            .foregroundColor(.white.opacity(0.6))
                            .padding()
                    }
                    .transition(.opacity)
                }
            }
            .background(Color.background)
        }
        .background(Color.background)
        .toolbarBackground(Color.blue, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    ListView()
}
