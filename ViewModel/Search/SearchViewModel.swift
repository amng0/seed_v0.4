//
//  SearchViewModel.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/15/24.
//

import Foundation
import FirebaseDatabase
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchResults: [SessionUserDetails] = []
    private var dbRef = Database.database().reference().child("users")
    private var searchCancellable: AnyCancellable?
    private let debounceInterval = 0.2 // 0.1 seconds
    
    func searchUsers(byName name: String) {
        // Execute two queries in parallel: one for first name and one for last name.
        let firstNameQuery = dbRef.queryOrdered(byChild: "firstName")
            .queryStarting(atValue: name)
            .queryEnding(atValue: name + "\u{f8ff}")
        
        let lastNameQuery = dbRef.queryOrdered(byChild: "lastName")
            .queryStarting(atValue: name)
            .queryEnding(atValue: name + "\u{f8ff}")
        
        let group = DispatchGroup()
        var firstNameResults: [SessionUserDetails] = []
        var lastNameResults: [SessionUserDetails] = []
        
        group.enter()
        observeQuery(firstNameQuery) { results in
            firstNameResults = results
            group.leave()
        }
        
        group.enter()
        observeQuery(lastNameQuery) { results in
            lastNameResults = results
            group.leave()
        }
        
        group.notify(queue: .main) {
            // Merge and remove duplicates.
            self.searchResults = Array(Set(firstNameResults + lastNameResults))
            print("Search results updated: \(self.searchResults.count) results")
        }
    }
    
    private func observeQuery(_ query: DatabaseQuery, completion: @escaping ([SessionUserDetails]) -> Void) {
        query.observeSingleEvent(of: .value, with: { snapshot in
            var results: [SessionUserDetails] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let uid = value["uid"] as? String {
                   
                   // Fix the line below by changing the comma to an equals sign
                   let email = value["email"] as? String ?? ""
                    
                    // Parse optional variables with default values
                    let firstName = value["firstName"] as? String ?? ""
                    let lastName = value["lastName"] as? String ?? ""
                    let username = value["username"] as? String ?? ""
                    let profileImageUrl = value["profileImageUrl"] as? String ?? ""
                    let friendCount = value["friendCount"] as? Int ?? 0
                    let bio = value["bio"] as? String ?? ""
                    let isFollowing = value["isFollowing"] as? Bool ?? false
                    let following = value["following"] as? [String] ?? [""]
                    
                    let userDetails = SessionUserDetails(uid: uid, email: email, firstName: firstName, lastName: lastName, username: username, profileImageUrl: profileImageUrl, friendCount: friendCount, bio: bio, isFollowing: isFollowing, following: following)
                    results.append(userDetails)
                }
            }
            completion(results)
            print("Query results fetched: \(results.count) results")
        })
    }

    
    func searchUsersDebounced(byName name: String) {
        // Cancel the previous search operation if it's still ongoing.
        // This ensures that only the latest search request is processed.
        searchCancellable?.cancel()
        
        // If the search query is empty, clear the search results and return.
        // This avoids unnecessary database queries.
        guard !name.isEmpty else {
            self.searchResults = []
            return
        }
        
        // Create a publisher that emits the search query.
        // The `Just` publisher emits a single value and then finishes.
        searchCancellable = Just(name)
            // The `debounce` operator delays the emission of the latest value.
            // It waits for the specified time interval (`debounceInterval`)
            // to ensure no new values are emitted in that time frame.
            // This is used here to wait for the user to stop typing.
            .debounce(for: .seconds(debounceInterval), scheduler: RunLoop.main)
            // The `sink` operator attaches a subscriber that triggers the search.
            // It calls `searchUsers(byName:)` with the latest search query
            // after the debounce interval.
            .sink { [weak self] in self?.searchUsers(byName: $0) }
    }
}
    
// Ensure SessionUserDetails conforms to Hashable for Set operations
extension SessionUserDetails: Hashable {
    static func == (lhs: SessionUserDetails, rhs: SessionUserDetails) -> Bool {
        return lhs.email == rhs.email // Assuming email is a unique identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(email) // Assuming email is a unique identifier
    }
}
