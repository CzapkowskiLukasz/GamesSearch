//
//  ListViewModel.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 19/01/2025.
//

import Foundation
import Combine
import SwiftUI

class ListViewModel: ObservableObject {
    private let creationDate: Date = .now
    
    @Published var games: [Game] = []
    @Published var search: String = ""
    @Published var isLoading: Bool = true
    @Published var selectedViewInx: Int = 0
    @Published var selectedView: ViewType = .vStack
    
    var proxy: ScrollViewProxy?
    var inx = 0
    
    private var pagination: Pagination = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        //fetchGames()
        
        setupBindings()
    }
    
    private func setupBindings() {
        $search
            .dropFirst()
            .removeDuplicates()
            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
            .sink{ [weak self] newValue in
                guard let self = self else { return }
                
                games = []
                pagination = .init()
                fetchGames(search: newValue)
                
            }
            .store(in: &cancellables)
        
        $selectedViewInx
            .dropFirst()
            .removeDuplicates()
            .sink{ [weak self] newValue in
                guard let self = self else { return }
                
                switch newValue {
                case 0:
                    self.selectedView = .list
                case 1:
                    self.selectedView = .scrollView
                case 2:
                    self.selectedView = .vStack
                default:
                    self.selectedView = .list
                }
                
            }
            .store(in: &cancellables)
        
        ReachabilityManager.shared.$isReachable
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] value in
                guard let self = self else {return }
                
                games = []
                
                fetchGames(search: self.search)
                
                proxy?.scrollTo("TOP")
            }
            .store(in: &cancellables)
    }
    
    private func offlineFetch(search: String? = nil) {
        do {
            if let search = search, search.notEmpty {
                let games = try GamesEntity.repository.searchGames(byName: search, pagination: pagination)
                self.games.append(contentsOf: games)
            } else {
                let games = try GamesEntity.repository.getAll(pagination: pagination)
                self.games.append(contentsOf: games)
            }
        } catch {
            print(error)
        }
        
    }
    
    private func onlineFetch(search: String? = nil) {
        Task {
            do {
                // Aktualizujemy isLoading na głównym wątku
                await MainActor.run {
                    isLoading = true
                }

                let games = try await self.download(search: search)

                // Aktualizujemy UI na głównym wątku
                await MainActor.run {
                    self.games.append(contentsOf: games)
                    isLoading = false
                }

                try GamesEntity.repository.insert(objects: games)

                var platformGame: [ParentPlatformGame] = []

                games.forEach {
                    let id = $0.id
                    let platforms = $0.parentPlatforms?.flatMap { $0.platform } ?? []

                    platformGame.append(contentsOf: platforms.map { .init(platformId: $0.id, gameId: id) })
                }

                try PlatformGameEntity.repository.insert(objects: platformGame)
                
                if inx < 4 {
                    inx += 1
                    pagination.increasePage()

                    fetchGames()
                }

            } catch {
                print(error)
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
    
    func fetchGames(search: String? = nil) {
        if ReachabilityManager.shared.isReachable {
            onlineFetch(search: search)
        } else {
            offlineFetch(search: search)
        }
    }
    
    private func download(search: String? = nil) async throws -> [Game] {
        return try await GamesRouter().getGames(
            search: search ?? self.search,
            pagination: pagination
        ).results
    }
    
    func check(game: Game) {
        if let index = games.lastIndex(where: {$0 == game}),
            index > games.count - 5,
           pagination.page * pagination.pageSize <= 200,
           !isLoading
        {
            isLoading = true
            pagination.increasePage()
            
            fetchGames()
        }
    }
    
    func stopTime() {
        print(Date.now.timeIntervalSince(creationDate))
    }
    
}
