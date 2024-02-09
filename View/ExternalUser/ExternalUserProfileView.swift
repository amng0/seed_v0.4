//
//  ExternalUserProfileView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/15/24.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct ExternalUserProfileView: View {
    @State private var isFollowing: Bool = false
    @State private var friendCount: Int = 0
    var sessionUser: SessionUserDetails
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                coverImage
                profileImage
                userInfo
                //bioSection
                followButton
                friendCountSection
                ExternalUserFeedView(userId: sessionUser.uid) 
            }
        }
        .background(Color("BackgroundColor")) // Assume you define this color in your assets
        .onAppear {
            observeFollowers()
            observeFriendCount(for: sessionUser.uid)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(sessionUser.username)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
    }
    
    var coverImage: some View {
        ZStack {
//            if let coverImageUrl = sessionUser.profileImageUrl, let url = URL(string: coverImageUrl) {
//                AsyncImage(url: url) { phase in
//                    switch phase {
//                        case .success(let image):
//                            image.resizable()
//                                 .aspectRatio(contentMode: .fill)
//                        case .failure, .empty:
//                            Color.gray
//                        @unknown default:
//                            EmptyView()
//                    }
//                }
//                .frame(height: 200)
//                .clipped()
//            } else {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .frame(height: 200)
            }
        }

    
    var profileImage: some View {
        AsyncImage(url: URL(string: sessionUser.profileImageUrl)) { phase in
            switch phase {
                case .success(let image):
                    image.resizable()
                         .scaledToFill()
                         .frame(width: 120, height: 120)
                         .clipShape(Circle())
                         .overlay(Circle().stroke(Color.white, lineWidth: 4))
                         .shadow(radius: 7)
                case .failure, .empty:
                    Image("default_profile")
                        .resizable()
                        .scaledToFit()
                @unknown default:
                    EmptyView()
            }
        }
        .offset(y: -60)
        .padding(.bottom, -60)
    }
    
    var userInfo: some View {
        VStack(alignment: .center, spacing: 5) {
            Text("\(sessionUser.firstName) \(sessionUser.lastName)")
                .font(.title)
                .fontWeight(.bold)
            
            if !sessionUser.username.isEmpty {
                Text("@\(sessionUser.username)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
//    var bioSection: some View {
//        if let bio = sessionUser.bio, !bio.isEmpty {
//            Text(bio)
//                .font(.body)
//                .multilineTextAlignment(.center)
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.secondary.opacity(0.1))
//                .cornerRadius(10)
//        } else {
//            EmptyView()
//        }
//    }
    
    var followButton: some View {
        Button(action: followUnfollowAction) {
            Text(isFollowing ? "Unfollow" : "Follow")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isFollowing ? Color.gray : Color.blue)
                .cornerRadius(25)
        }
        .padding(.horizontal)
        .animation(.default, value: isFollowing) // Add an animation for when isFollowing changes
    }
    
    var friendCountSection: some View {
        HStack {
            Image(systemName: "person.3.fill")
            Text("\(friendCount) Tribe Members")
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.8))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    func followUnfollowAction() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("Not logged in")
            return
        }
        
        let externalUserUID = sessionUser.uid
        let loggedInUserFollowingRef = Database.database().reference().child("users").child(currentUserUID).child("following")
        
        isFollowing.toggle() // Assume the action will be successful and optimistically update the UI
        
        if !isFollowing { // Note the change here. The logic was inverted.
            // If the user is currently followed, unfollow them.
            loggedInUserFollowingRef.child(externalUserUID).removeValue { error, _ in
                if let error = error {
                    print("Error unfollowing user: \(error.localizedDescription)")
                    self.isFollowing = true // Revert the UI change if there was an error
                } else {
                    print("Unfollowed user successfully")
                    decrementFriendCount(for: externalUserUID)
                }
            }
        } else {
            // If the user is currently not followed, follow them.
            loggedInUserFollowingRef.child(externalUserUID).setValue(true) { error, _ in
                if let error = error {
                    print("Error following user: \(error.localizedDescription)")
                    self.isFollowing = false // Revert the UI change if there was an error
                } else {
                    print("Followed user successfully")
                    incrementFriendCount(for: externalUserUID)
                }
            }
        }
    }


    
    func decrementFriendCount(for userUID: String) {
        let friendCountRef = Database.database().reference().child("users").child(userUID).child("friendCount")
        
        friendCountRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            var value = currentData.value as? Int ?? 0
            value = max(value - 1, 0)  // Avoid negative count
            currentData.value = value
            return TransactionResult.success(withValue: currentData)
        }) { error, committed, snapshot in
            if let error = error {
                print(error.localizedDescription)
            }
            if committed, let newCount = snapshot?.value as? Int {
                DispatchQueue.main.async {
                    self.friendCount = newCount
                }
            }
        }
    }

    
    func observeFollowers() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("Not logged in")
            return
        }

        let followingRef = Database.database().reference().child("users").child(currentUserUID).child("following").child(sessionUser.uid)

        followingRef.observeSingleEvent(of: .value) { snapshot in
            // Directly access self since ExternalUserProfileView is a struct
            DispatchQueue.main.async {
                // Set `isFollowing` to true if the snapshot exists (meaning the current user is following the profile)
                self.isFollowing = snapshot.exists()
                print("Is following: \(self.isFollowing)")
            }
        }
    }
    
    func observeFriendCount(for userUID: String) {
        let friendCountRef = Database.database().reference().child("users").child(userUID).child("friendCount")
        
        friendCountRef.observe(.value, with: { snapshot in
            if let count = snapshot.value as? Int {
                DispatchQueue.main.async {
                    self.friendCount = count
                }
            } else {
                // If the value is not an Int (for example, if the node does not exist), set friendCount to 0
                DispatchQueue.main.async {
                    self.friendCount = 0
                }
            }
        })
    }


    func incrementFriendCount(for userUID: String) {
        let friendCountRef = Database.database().reference().child("users").child(userUID).child("friendCount")
        
        friendCountRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            var value = currentData.value as? Int ?? 0
            value += 1
            currentData.value = value
            return TransactionResult.success(withValue: currentData)
        }) { error, committed, snapshot in
            if let error = error {
                print(error.localizedDescription)
            }
            if committed, let newCount = snapshot?.value as? Int {
                DispatchQueue.main.async {
                    self.friendCount = newCount
                }
            }
        }
    }


    
    
    private func checkFollowingStatus() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let externalUserUID = sessionUser.uid
        
        let followersRef = Database.database().reference().child("users").child(externalUserUID).child("followers")
        
        // Check if the logged-in user's UID exists in the followers list
        followersRef.observeSingleEvent(of: .value) { snapshot in
            if snapshot.hasChild(currentUserUID) {
                isFollowing = true // User is following the external user
            } else {
                isFollowing = false // User is not following the external user
            }
        }
    }
}

