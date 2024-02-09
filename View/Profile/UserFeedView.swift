//
//  UserFeedView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/28/24.
//

import SwiftUI

struct UserFeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.feedPosts, id: \.id) { post in
                        FeedPostView(viewModel: viewModel, post: post, userDetails: post.userDetails)
                    }
                    
                }
            }
            .onAppear {
                viewModel.fetchFeedPosts(){
                }
            }
        }
    }
}


