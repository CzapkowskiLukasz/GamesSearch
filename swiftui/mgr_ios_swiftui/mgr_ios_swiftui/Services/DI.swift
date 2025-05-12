//
//  DI.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 15/03/2025.
//

import Foundation
import Swinject

enum AppDI {
    
    static func configure() {
        DI.container.register(
            ConnectivityService.self,
            factory: { _ in ConnectivityService() }
        )
        .inObjectScope(.container)
    }
}

enum DI {
    
    static let container: Container = .init()
    
    static let synchronizedResolver: Resolver = container.synchronize()
    
    // MARK: only for tests
    
    static func register<Service>(
        _ serviceType: Service.Type,
        name: String? = nil,
        factory: @escaping (Resolver) -> Service,
        objectScope: ObjectScope = .container
    ) {
        DI.container.register(
            serviceType,
            name: name,
            factory: factory
        )
        .inObjectScope(objectScope)
    }
    
}
