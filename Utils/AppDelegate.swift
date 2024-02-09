//
//  AppDelegate.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/28/24.
//
import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configure Firebase here if needed
        FirebaseApp.configure()
        return true
    }
    
    // Add other delegate methods as needed
}

