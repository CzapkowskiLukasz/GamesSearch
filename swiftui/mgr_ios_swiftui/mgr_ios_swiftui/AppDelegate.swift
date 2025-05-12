//
//  AppDelegate.swift
//  SwiftUI_mgr
//
//  Created by Łukasz on 15/03/2025.
//

import SwiftUI
import Foundation

class AppDelegate: NSObject, UIApplicationDelegate {
    
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        MainDatabase.init()
        AppDI.configure()
        
        return true
    }
    
}
