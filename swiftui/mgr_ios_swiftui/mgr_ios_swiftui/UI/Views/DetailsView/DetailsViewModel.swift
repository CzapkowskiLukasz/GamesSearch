//
//  DetailsViewModel.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 02/02/2025.
//

import Foundation
import SwiftUI

class DetailsViewModel: ObservableObject {
    @Published var game: Game
    @Published var details: GameDetails?
    
    var photoUrls: [String?] = []
    
    init(game: Game) {
        self.game = game
        
        photoUrls.append(game.backgroundImage)
        photoUrls.append(contentsOf: game.shortScreenshots.map({$0.image}))
        
        photoUrls = photoUrls.enumerated().filter { (index, element) in
            return photoUrls.prefix(index).contains(element) == false
        }.map { $0.element }
        
        getDetails()
    }
    
    func getDetails() {
        Task {
            details = try await GamesRouter().gameDetails(gameId: "\(game.id)")
        }
    }
    
    func getMaxValue() -> Int {
        return [game.addedByStatus?.yet, game.addedByStatus?.beaten, game.addedByStatus?.dropped, game.addedByStatus?.owned, game.addedByStatus?.toplay, game.addedByStatus?.playing].flatMap( { $0 }).max() ?? 0
    }
    
}
