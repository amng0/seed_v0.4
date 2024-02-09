//
//  App.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 12/25/23.
//

import SwiftUI
import Firebase

@main
struct SeedApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isAuthCheckComplete {
                    if authViewModel.isAuthenticated {
                        MainTabView()
                    } else {
                        LoginView()
                    }
                } else {
                    // TODO: Show splash screen
                }
            }
        }
    }
}
