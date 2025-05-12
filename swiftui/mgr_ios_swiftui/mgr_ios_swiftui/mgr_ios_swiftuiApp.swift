//
//  SwiftUI_mgrApp.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 02/01/2025.
//

import SwiftUI
import SwiftData

@main
struct mgr_ios_swiftuiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var dataManager: DataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            ListView()
        }
    }
}

class DataManager {
    init () {
        //MainDatabase.init()
        //AppDI.configure()
        
        fetchPlatforms()
    }
    
    func fetchPlatforms() {
        
        Task {
            do {
                var platforms = try await PlatformRouter().getPlatform().results
                
                try ParentPlatformEntity.repository.insert(objects: platforms)
            } catch {
                print(error)
            }
        }
        
    }
}
