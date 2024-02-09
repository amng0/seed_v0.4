//
//  ProfileViewModel.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 2/4/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var feedPosts: [FeedPost] = []
    @Published var friendCount: Int = 0
    
    // Fetch user's feed posts
    func fetchUserFeedPosts(userId: String) {
        // Implement the fetching logic here
        // Update self.feedPosts accordingly
    }
    
    // Fetch user's friend count
    func fetchFriendCount(userId: String) {
        let friendCountRef = Database.database().reference().child("users").child(userId).child("friendCount")
        friendCountRef.observeSingleEvent(of: .value) { snapshot in
            if let count = snapshot.value as? Int {
                DispatchQueue.main.async {
                    self.friendCount = count
                }
            }
        }
    }
    
    func observeFriendCount(for userUID: String) {
        let friendCountRef = Database.database().reference().child("users").child(userUID).child("friendCount")
        
        friendCountRef.observe(.value, with: { [weak self] snapshot in
            if let count = snapshot.value as? Int {
                DispatchQueue.main.async {
                    self?.friendCount = count
                }
            } else {
                DispatchQueue.main.async {
                    self?.friendCount = 0 // This line sets friend count to 0 if the snapshot doesn't contain an Int
                }
            }
        })
    }
}




struct FriendCountView: View {
    var friendCount: Int
    
    var body: some View {
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
}

