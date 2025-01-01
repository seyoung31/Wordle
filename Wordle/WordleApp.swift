//
//  WordleApp.swift
//  Wordle
//
//  Created by Seyoung on 2022/07/06.
//

import SwiftUI
import Firebase
//import FirebaseAnalytics

@main
struct WordleApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
            LoginView()
                .environmentObject(viewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       
        FirebaseApp.configure()
        
        return true
    }
}

// adjust width and height depending on device screen
