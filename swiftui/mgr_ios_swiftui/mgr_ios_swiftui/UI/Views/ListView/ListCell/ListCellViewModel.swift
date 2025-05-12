//
//  ListCellViewModel.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 02/01/2025.
//

import Foundation
import Combine
import SwiftUI

class ListCellViewModel: ObservableObject {
    let game: Game
    
    @Published var isOnline: Bool = ReachabilityManager.shared.isReachable
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(game: Game) {
        self.game = game
    }
    
    private func setupBindings() {
        ReachabilityManager.shared.$isReachable
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self = self else {return }
                
                withAnimation {
                    self.isOnline = newValue
                }
            }
            .store(in: &cancellables)
    }
}
