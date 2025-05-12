//
//  ReachabilityManager.swift
//

import Foundation
import Alamofire
import Combine

class ReachabilityManager: ObservableObject {
    
    static let shared = ReachabilityManager()
    
    @Published
    private(set) var isReachable: Bool = true
    
    @Published
    private(set) var status: NetworkReachabilityManager.NetworkReachabilityStatus
    
    var statusDidChanged: Published<NetworkReachabilityManager.NetworkReachabilityStatus>.Publisher { $status }
    
    var reachabilityDidChanged: Published<Bool>.Publisher { $isReachable }
    
    private let manager = NetworkReachabilityManager()
    
    init() {
        isReachable = manager?.isReachable ?? false
        status = manager?.status ?? .unknown
        
        manager?.startListening(onUpdatePerforming: { [weak self] status in
            guard let self else { return }
            
            self.status = status
            
            switch status {
            case .reachable:
                self.isReachable =  true
            default:
                self.isReachable = false
            }
        })
    }
    
    deinit {
        manager?.stopListening()
    }
}
