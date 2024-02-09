//
//  FeedPostView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/21/24.
//

import SwiftUI

struct FeedPostView: View {
    @ObservedObject var viewModel: FeedViewModel
    let post: FeedPost
    var userDetails: SessionUserDetails
    @State private var isShowingDetail = false
    
    
    var body: some View {
        NavigationLink(destination: PostDetailView(viewModel: viewModel, post: post, profileImageUrl: userDetails.profileImageUrl, userDetails: post.userDetails), isActive: $isShowingDetail) {
            EmptyView()
        }
        .opacity(0) // Make the NavigationLink invisible
        
        VStack(alignment: .leading, spacing: 8) {
            UserInfoView(firstName: userDetails.firstName, lastName: userDetails.lastName, username: userDetails.username, profileImageUrl: post.userDetails.profileImageUrl, timestamp: post.timestamp)
            if let caption = post.caption {
                Text(caption)
                    .font(.body)
                    .padding(.vertical, 4)
            }
            PostActionsView(viewModel: viewModel, post: post, userDetails: userDetails)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(0)
        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
        .border(Color.gray.opacity(0.2), width: 0.5)
        .onTapGesture {
            self.isShowingDetail = true
        }
    }
}


struct UserInfoView: View {
    var firstName: String
    var lastName: String
    var username: String
    var profileImageUrl: String
    var timestamp: Date
    
    var body: some View {
        HStack {
            // Load and display the user's profile image
            AsyncImage(url: URL(string: profileImageUrl)) { image in
                image.resizable()
            } placeholder: {
                Circle().foregroundColor(.gray) // Placeholder for the profile image
            }
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack{
                    Text("\(firstName) \(lastName)")
                        .font(.headline)
                        .fontWeight(.bold) +
                    Text(" @\(username)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Text(timestamp.timeAgoDisplay())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
}



extension Date {
    func timeAgoDisplay() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: self, to: now) ?? "recently"
    }
}

struct PostActionsView: View {
    @ObservedObject var viewModel: FeedViewModel
    let post: FeedPost
    var userDetails: SessionUserDetails
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                let postIdString = post.id.uuidString
                if post.isLikedByCurrentUser {
                    viewModel.unlikePost(postId: postIdString)
                } else {
                    viewModel.likePost(postId: postIdString)
                }
            }) {
                Image(systemName: post.isLikedByCurrentUser ? "heart.fill" : "heart")
                    .foregroundColor(post.isLikedByCurrentUser ? .red : .gray) // Red when liked
                
            }
            Text("\(post.likes)")
            
            // Spacer()
            
            Image(systemName: "message")
            Text("\(post.comments?.count ?? 0)")
        }
        .foregroundColor(.secondary)
        .font(.subheadline)
        .padding(.vertical, 8)
    }
}

