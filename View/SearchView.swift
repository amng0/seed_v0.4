//
//  SearchView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/15/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchQuery = ""
    @FocusState private var isInputActive: Bool  // Define a focus state

    var body: some View {
        NavigationView {
            VStack {
                // Enhanced Search input field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search Users", text: $searchQuery)
                        .focused($isInputActive)  // Bind the text field to the focus state
                        .textFieldStyle(PlainTextFieldStyle())
                        .onAppear {
                            isInputActive = true  // Activate the text field when the view appears
                        }
                        .foregroundColor(.primary) // Use primary color for text which adapts automatically
                }
                .padding()
                .background(Color(UIColor.systemGray6)) // Use UIColor to adapt the color automatically
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
                .animation(.easeInOut, value: searchQuery)
                .onChange(of: searchQuery) { newValue in
                    print("Search query changed to: \(newValue)")
                    viewModel.searchUsers(byName: newValue)
                }

                // Results list
                List(viewModel.searchResults, id: \.email) { user in
                    NavigationLink(destination: ExternalUserProfileView(sessionUser: user)) {
                        HStack {
                            Circle()
                                .fill(Color.blue) // Consider using .accentColor or another adaptive color
                                .frame(width: 40, height: 40)
                                .overlay(Text(String(user.firstName.prefix(1)) + String(user.lastName.prefix(1)))
                                    .foregroundColor(.white)) // Ensure contrast is readable
                            VStack(alignment: .leading) {
                                Text(user.firstName + " " + user.lastName)
                                    .font(.headline)
                                    .foregroundColor(.primary) // Use primary color which adapts automatically
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary) // Use secondary color which adapts automatically
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("User Search", displayMode: .inline)
            .background(Color(.systemBackground)) // Use system background color
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.blue) // Use this to set a global tint color that adapts to dark mode
    }
}

