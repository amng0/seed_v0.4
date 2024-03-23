////
////  ExternalUserFeed.swift
////  seed_v0.4
////
////  Created by Amie Nguyen on 1/28/24.
////

import SwiftUI

struct ExternalUserFeedView: View {
    var userId: String // External user's ID
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // This is where the fetched posts will be displayed
                ForEach(viewModel.externalUserPosts) { post in
                    FeedPostView(viewModel: viewModel, post: post, userDetails: post.userDetails)
                }
            }
            .onAppear {
                viewModel.fetchExternalUserFeedPosts(userId: userId) {_ in
                    // This closure can be used if you need to do something right after fetching
                }
            }
        }
    }
}
