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
    
    // Access the current color scheme
    @Environment(\.colorScheme) var colorScheme
    
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
        .background(Color(.systemBackground)) // Adapt background
        .cornerRadius(0)
        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.05) : Color.black.opacity(0.05), radius: 1, x: 0, y: 1) // Conditional shadow
        .border(colorScheme == .dark ? Color.gray.opacity(0.5) : Color.gray.opacity(0.2), width: 0.5) // Conditional border
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
            AsyncImage(url: URL(string: profileImageUrl)) { phase in
                switch phase {
                case .empty:
                    Circle().foregroundColor(.gray) // Placeholder with the exact dimensions
                        .frame(width: 44, height: 44)
                case .success(let image):
                    image.resizable()
                         .scaledToFill()
                         .frame(width: 44, height: 44)
                         .clipShape(Circle())
                         .transition(.opacity) // Fade-in transition
                case .failure:
                    Circle().foregroundColor(.gray) // Error placeholder
                        .frame(width: 44, height: 44)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 44, height: 44)
            
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
                viewModel.toggleLike(for: post.id.uuidString)
            }) {
                Image(systemName: post.isLikedByCurrentUser ? "heart.fill" : "heart")
                    .foregroundColor(post.isLikedByCurrentUser ? .red : .gray)
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

