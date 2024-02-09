//
//  LoginController.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 7/27/23.
//

// TO DO:
// Box around email/password container
// Change color of icons for email and password containers
// Make placeholder text grey
// Choose color for bottomStack text

// Forgot password field controller

import UIKit

import SwiftUI
import Firebase
 
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isShowingRegistration = false
    @State private var isMainTabPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image("seedlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 69, height: 69)
                    .padding(.top)
                
                Text("seed")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.black)
                
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                Button("Login") {
                    handleLogin()
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(25)
                .padding(.horizontal, 25)
                
                Spacer()
                
                VStack {
                    Button("Don't have an account? Sign Up") {
                        self.isShowingRegistration = true
                    }
                    .sheet(isPresented: $isShowingRegistration) {
                        RegistrationView()
                    }
                    
                    Button("Forgot Password") {
                        // Implement forgot password functionality
                        print("Forgot password tapped")
                    }
                }
                .padding(.bottom)
            }
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $isMainTabPresented) {
            MainTabView()
        }
    }
    
    func handleLogin() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                return
            }
            // Successfully logged in
            DispatchQueue.main.async {
                self.isMainTabPresented = true
            }
        }
    }
    
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
}


