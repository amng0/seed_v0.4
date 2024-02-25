//
//  FeedView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/21/24.
//
//  TODO:
//  -Implement notifications
//  -Add profile picture to navigation bar

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @State private var isShowingNotifications = false
    @State private var showingCreateGoalView = false
    @State private var isFetchCompleted = false

    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.feedPosts.isEmpty && isFetchCompleted {
                    // Split the message into two parts
                    let messagePart1 = Text("Welcome to Seed.\n\n")
                        .foregroundColor(.gray)
                    
                    let messagePart2 = Text("Create a new goal.")
                        .underline()
                        .foregroundColor(.gray)
                    
                    let combinedMessage = messagePart1 + messagePart2
                    
                    // Invisible NavigationLink to trigger programmatically
                    NavigationLink(destination: CreateUpcomingGoalsView(initialGoalType: .physical), isActive: $showingCreateGoalView) {
                        EmptyView()
                    }
                    // Use the combined message with onTapGesture
                    combinedMessage
                        .padding()
                        .onTapGesture {
                            self.showingCreateGoalView = true
                        }
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.feedPosts, id: \.id) { post in
                            FeedPostView(viewModel: viewModel, post: post, userDetails: post.userDetails)
                        }
                    }
                }
            }
            .refreshable {
                isFetchCompleted = false // Reset before refreshing
                viewModel.fetchFeedPostsFromFollowingUsers {
                    viewModel.fetchFeedPostsFromFollowingUsers() {
                        isFetchCompleted = true // Mark as completed after fetch
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Image(systemName: "line.horizontal.3")
//                }
                ToolbarItem(placement: .principal) {
                    Image("seedlogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(destination: NotificationsView(), isActive: $isShowingNotifications) {
//                        Button(action: {
//                            isShowingNotifications = true
//                        }) {
//                            Image(systemName: "bell")
//                        }
//                    }
//                }
            }
        }
        .onAppear {
            isFetchCompleted = false // Reset before fetching
            viewModel.fetchFeedPostsFromFollowingUsers {
                viewModel.fetchFeedPostsFromFollowingUsers() {
                    isFetchCompleted = true // Mark as completed after fetch
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RefreshFeedNotification"))) { _ in
            isFetchCompleted = false // Reset before fetching
            viewModel.fetchFeedPostsFromFollowingUsers {
                viewModel.fetchFeedPostsFromFollowingUsers() {
                    isFetchCompleted = true // Mark as completed after fetch
                }
            }
        }
    }
}


