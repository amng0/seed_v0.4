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

// Defines the main view for the feed in the app.
struct FeedView: View {
    // ViewModel that manages the data for the feed.
    @StateObject var viewModel = FeedViewModel()
    // State variables to manage UI flow and interactions.
    @State private var isShowingNotifications = false
    @State private var showingCreateGoalView = false
    @State private var isFetchCompleted = false

    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.feedPosts.isEmpty && isFetchCompleted {
                    // Use VStack for stacking text views vertically.
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome to Seed.\n\n")
                            .foregroundColor(.gray)
                        Text("Create a new goal.")
                            .underline()
                            .foregroundColor(.gray)
                            .onTapGesture {
                                self.showingCreateGoalView = true // Triggers navigation to create a new goal.
                            }
                    }
                    .padding()
                    // NavigationLink to trigger programmatically for creating a new goal.
                    NavigationLink("", destination: CreateUpcomingGoalsView(initialGoalType: .physical), isActive: $showingCreateGoalView)
                } else {
                    // Displays feed posts using a lazy stack for performance.
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.feedPosts, id: \.id) { post in
                            FeedPostView(viewModel: viewModel, post: post, userDetails: post.userDetails)
                        }
                    }
                }
            }
            .refreshable {
                // Refresh action to reload feed posts.
                refreshFeed()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    // Displays the app logo in the navigation bar.
                    Image("seedlogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
            }
        }
        .onAppear {
            refreshFeed() // Fetches feed posts when the view appears.
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RefreshFeedNotification"))) { _ in
            refreshFeed() // Listens for a notification to refresh the feed.
        }
    }
    
    /// Refreshes the feed by fetching new posts.
    private func refreshFeed() {
        isFetchCompleted = false // Indicates the start of a fetch operation.
        viewModel.fetchFeedPostsFromFollowingUsers {
            isFetchCompleted = true // Indicates the completion of the fetch operation.
        }
    }
}
