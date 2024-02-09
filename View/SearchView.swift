//
//  SearchView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/15/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    //@State var userModel: User?  // Now using the User model

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
                }
                .padding()
                .background(Color(.systemGray6))
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
                                .fill(Color.blue)
                                .frame(width: 40, height: 40)
                                .overlay(Text(String(user.firstName.prefix(1)) + String(user.lastName.prefix(1))))
                            VStack(alignment: .leading) {
                                Text(user.firstName + " " + user.lastName)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("User Search", displayMode: .inline)
            .background(Color.white)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
