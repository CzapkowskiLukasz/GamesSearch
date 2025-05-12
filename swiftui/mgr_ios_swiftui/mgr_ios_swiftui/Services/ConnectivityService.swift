//
//  ConnectivityService.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 15/03/2025.
//

import Foundation
import Combine

class ConnectivityService {
    
    let reachabilityManager: ReachabilityManager
    
    @Published private(set) var isOnline: Bool
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(reachabilityManager: ReachabilityManager = .shared) {
        self.reachabilityManager = reachabilityManager
        self._isOnline = .init(initialValue: reachabilityManager.isReachable)
        self.setupBindings()
    }
    
    private func setupBindings() {
        reachabilityManager.reachabilityDidChanged
            .removeDuplicates()
            .sink { [weak self] value in
                guard let self else { return }
                isOnline = value
            }
            .store(in: &cancellables)
    }
    
}
