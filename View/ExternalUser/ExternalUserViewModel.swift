//
//  ExternalUserViewModel.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/20/24.
//

import Foundation

class ExternalUserProfileViewModel: ObservableObject {
    @Published var externalUser: SessionUserDetails
    @Published var isFollowing: Bool
    @Published var friendCount: Int
    @Published var bio: String

    init(externalUser: SessionUserDetails) {
        self.externalUser = externalUser
        self.isFollowing = externalUser.isFollowing ?? false // Unwrap the optional or provide a default value
        self.friendCount = externalUser.friendCount ?? 0 // Unwrap the optional or provide a default value
        self.bio = externalUser.bio ?? "" // Unwrap the optional or provide a default value
    }

    func followUnfollowAction() {
        if let isFollowing = externalUser.isFollowing {
            if isFollowing {
                // User is already following, perform unfollow action
                // Decrement friendCount and update UI accordingly
                friendCount -= 1
            } else {
                // User is not following, perform follow action
                // Increment friendCount and update UI accordingly
                friendCount += 1
            }
            
            // Toggle isFollowing state
            externalUser.isFollowing = !isFollowing
        }
        
        // Update externalUser properties (in-memory) for the current session
        externalUser.friendCount = friendCount
    }
    
    
    
}

