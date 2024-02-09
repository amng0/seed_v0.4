//
//  AuthViewModel.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/28/24.
//

// AuthViewModel.swift

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isAuthCheckComplete: Bool = false

    init() {
        self.isAuthenticated = false // Default to false
        self.checkAuthStatus()
    }

    func checkAuthStatus() {
        // Assuming Firebase Auth is set up correctly
        Auth.auth().addStateDidChangeListener { auth, user in
            DispatchQueue.main.async {
                self.isAuthenticated = user != nil
                self.isAuthCheckComplete = true // Mark auth check as complete
            }
        }
    }
}
