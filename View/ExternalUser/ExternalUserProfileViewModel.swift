//
//  ExternalUserProfileViewModel.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/20/24.
//

import Foundation
import Combine
import Firebase

class ExternalUserProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isFollowing: Bool = false
    @Published var friendCount: Int = 0

    private var dbRef = Database.database().reference()
    private var cancellables = Set<AnyCancellable>()

    init(user: User) {
        self.user = user
        self.isFollowing = user.isFollowed
        self.tribeMemberCount = user.friends
        fetchUserDetails(userUID: user.uid)  // Fetch details using UID
    }

    private func fetchUserDetails(userUID: String) {
        // Fetch user details from Firebase
        dbRef.child("users").child(userUID).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                DispatchQueue.main.async {
                    self.user = user
                    self.isFollowing = user.isFollowed
                    self.tribeMemberCount = user.friends
                }
            } catch {
                print("Error decoding user: \(error)")
            }
        }
    }

    func toggleFollowStatus() {
        guard let user = user else { return }
        isFollowing.toggle()
        let newFriendCount = isFollowing ? user.friends + 1 : user.friends - 1

        // Update the local state
        self.tribeMemberCount = newFriendCount

        // Update the follow status and friend count in Firebase
        let updates = ["isFollowed": isFollowing, "friends": newFriendCount] as [String : Any]
        dbRef.child("users").child(user.uid).updateChildValues(updates) { error, _ in
            if let error = error {
                print("Error updating user: \(error)")
                // Rollback local changes in case of error
                DispatchQueue.main.async {
                    self.isFollowing.toggle()
                    self.tribeMemberCount = user.friends
                }
            }
        }
    }
}
