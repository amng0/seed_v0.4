//
//  UserProfileViewModel.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 12/27/23.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase

class UserProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var goalPosts: [GoalPost] = []
    
    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            do {
                if snapshot.exists(), let userData = snapshot.value as? [String: Any] {
                    let data = try JSONSerialization.data(withJSONObject: userData, options: [])
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.currentUser = user
                } else {
                    print("No user found for the uid")
                }
            } catch {
                print("Error decoding user:", error)
            }
        }
    }
    
    func fetchUserGoalPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(uid).child("goalPosts")
        
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            do {
                if snapshot.exists(), let goalPostDict = snapshot.value as? [String: Any] {
                    let data = try JSONSerialization.data(withJSONObject: goalPostDict, options: [])
                    let fetchedGoalPosts = try JSONDecoder().decode([String: GoalPost].self, from: data)
                    self.goalPosts = Array(fetchedGoalPosts.values)
                } else {
                    self.goalPosts = []
                    print("No goal posts found for the user")
                }
            } catch {
                print("Error decoding goal posts:", error)
            }
        }
    }
}

