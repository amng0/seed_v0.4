//
//  FeedViewModel.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/15/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase

class FeedViewModel: ObservableObject {
    @Published var feedPosts: [FeedPost] = []
    @Published var fetchedFeedPosts: [FeedPost] = []
    @Published var externalUserPosts: [FeedPost] = []
    
    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
    
    
    func setupAuth(feedPost: FeedPost) {
        // safely unwrap userID using firebase Auth
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        uploadFeedPost(with: userID, feedPost: feedPost)
    }
    
    func fetchUserDetails(userId: String, completion: @escaping (SessionUserDetails?) -> Void) {
        let userRef = Database.database().reference().child("users").child(userId)
        userRef.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            let user = SessionUserDetails(dictionary: value) // Convert to SessionUserDetails
            completion(user)
        }
    }
    
    func uploadFeedPost(with uid: String, feedPost: FeedPost){
        let firebaseRef = Database.database().reference()
        let data = try? JSONEncoder().encode(feedPost)
        
        if let data = data, let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            let feedPostRef = firebaseRef.child("users").child(uid).child("feedPosts").child("\(feedPost.id)")
            
            feedPostRef.updateChildValues(jsonDict) { (error, ref) in
                if let error = error {
                    print("Error updating board data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchFeedPosts(completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("DEBUG: User ID is nil")
            return
        }
        
        let ref = Database.database().reference().child("users").child(userID).child("feedPosts")
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self, snapshot.exists(), let feedPostDict = snapshot.value as? [String: Any] else {
                DispatchQueue.main.async {
                    completion() // Call completion if no posts or error
                }
                return
            }
            
            var tempFeedPosts = [FeedPost]()
            let group = DispatchGroup()
            
            for (postId, postData) in feedPostDict {
                if let postDataDict = postData as? [String: Any], let postDataJson = try? JSONSerialization.data(withJSONObject: postDataDict), var feedPost = try? JSONDecoder().decode(FeedPost.self, from: postDataJson) {
                    
                    group.enter()
                    let likeRef = Database.database().reference().child("posts").child(postId).child("likes").child(userID)
                    likeRef.observeSingleEvent(of: .value, with: { snapshot in
                        feedPost.isLikedByCurrentUser = snapshot.exists() // Set like status
                        tempFeedPosts.append(feedPost)
                        group.leave()
                    })
                }
            }
            
            group.notify(queue: .main) {
                self.feedPosts = tempFeedPosts.sorted { $0.timestamp > $1.timestamp }
                completion()
            }
        }
    }

    
//    func fetchFeedPosts(completion: @escaping () -> Void) {
//        guard let userID = Auth.auth().currentUser?.uid else {
//            print("DEBUG: User ID is nil")
//            return
//        }
//
//        let ref = Database.database().reference().child("users").child(userID).child("feedPosts")
//        print("DEBUG: Fetching feed posts from Firebase path: \(ref)")
//
//        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
//            guard let self = self else { return }
//
//            if !snapshot.exists() {
//                print("DEBUG: Snapshot does not exist")
//                DispatchQueue.main.async {
//                    self.feedPosts = []
//                    completion()
//                }
//                return
//            }
//
//            guard let feedPostDict = snapshot.value as? [String: Any] else {
//                print("DEBUG: Snapshot value is not a valid dictionary")
//                DispatchQueue.main.async {
//                    completion() // Also call completion here if the data is not in the expected format
//                }
//                return
//            }
//
//            print("DEBUG: Retrieved feed posts dictionary: \(feedPostDict)")
//
//            do {
//                var tempFeedPosts = [FeedPost]()
//                for (postId, postData) in feedPostDict {
//                    print("DEBUG: Processing post with ID: \(postId)")
//                    if let postDataDict = postData as? [String: Any],
//                       let postDataJson = try? JSONSerialization.data(withJSONObject: postDataDict) {
//                        do {
//                            let feedPost = try JSONDecoder().decode(FeedPost.self, from: postDataJson)
//                            tempFeedPosts.append(feedPost)
//                        } catch {
//                            print("DEBUG: Error decoding post \(postId): \(error)")
//                        }
//                    } else {
//                        print("DEBUG: Invalid data format for post \(postId)")
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.feedPosts = tempFeedPosts.sorted { $0.timestamp > $1.timestamp }
//                    completion()
//                }
//            } catch {
//                print("DEBUG: Error decoding feed posts: \(error)")
//            }
//        }
//    }
    
    func fetchFeedPostsFromFollowingUsers(completion: @escaping () -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            // Handle the case when the current user is not authenticated
            print("DEBUG: Current user is not authenticated.")
            return
        }
    
        // Reference to the logged-in user's following node
        let loggedInUserFollowingRef = Database.database().reference().child("users").child(currentUserUID).child("following")

        loggedInUserFollowingRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }

            if snapshot.exists() {
                // Expecting the following node to be a dictionary with UIDs as keys
                if let followingDict = snapshot.value as? [String: Bool] {
                    let followingUIDs = followingDict.keys
                    print("DEBUG: Found following UIDs: \(followingUIDs)")

                    // Create a dispatch group to handle multiple asynchronous calls
                    let dispatchGroup = DispatchGroup()

                    for followingUID in followingUIDs {
                        print("DEBUG: Fetching feed posts for user with UID: \(followingUID)")

                        // Enter the dispatch group before making the fetchExternalUserPosts call
                        dispatchGroup.enter()

                        // Fetch feed posts for each user the current user is following
                        self.fetchExternalUserPosts(userId: followingUID) {
                            // Leave the dispatch group when the fetchExternalUserPosts call is complete
                            dispatchGroup.leave()
                        }
                    }

                    // Notify when all fetchExternalUserPosts calls are complete
                    dispatchGroup.notify(queue: .main) {
                                   // Apply deduplication and sorting after all posts are fetched
                                   self.feedPosts = self.removeDuplicatesAndSort(posts: self.feedPosts)
                                   print("DEBUG: All fetchExternalUserPosts calls are complete. Feed posts deduplicated and sorted.")
                               }
                } else {
                    print("DEBUG: Following UIDs not in the expected format.")
                }
            } else {
                print("DEBUG: No following UIDs found.")
            }
        }
        completion()
    }

    func fetchExternalUserPosts(userId: String, completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("users").child(userId).child("feedPosts")
        print("DEBUG: Fetching feed posts for external user from Firebase path: \(ref)")

        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }

            if !snapshot.exists() {
                print("DEBUG: No posts found for external user.")
                // You can choose to handle this case differently if needed.
                // For now, let's not add any external user posts if there are none.
            } else {
                guard let feedPostDict = snapshot.value as? [String: Any] else {
                    print("DEBUG: Snapshot value is not a valid dictionary")
                    completion() // Call completion to notify that the fetch is complete
                    return
                }

                self.processFeedPosts(feedPostDict: feedPostDict)

                // Call completion to notify that the fetch is complete
                completion()
            }
        }
    }
    
    private func updateLocalPostLikeStatus(postId: String, liked: Bool) {
        if let index = feedPosts.firstIndex(where: { $0.id.uuidString == postId }) {
            DispatchQueue.main.async {
                self.feedPosts[index].isLikedByCurrentUser = liked
            }
        }
    }

    
//    func fetchExternalUserProfileFeedPosts(userId: String) {
//        let ref = Database.database().reference().child("users").child(userId).child("feedPosts")
//
//        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
//            guard let self = self else { return }
//
//            if !snapshot.exists() {
//                print("DEBUG: No posts found for external user.")
//                // You can choose to handle this case differently if needed.
//                // For now, let's not add any external user posts if there are none.
//            } else {
//                guard let feedPostDict = snapshot.value as? [String: Any] else {
//                    print("DEBUG: Snapshot value is not a valid dictionary")
//                    return
//                }
//
//                self.processFeedPosts(feedPostDict: feedPostDict)
//
//                // Notify that the fetch is complete
//                // You might want to use a completion handler here if you need to perform any actions after fetching.
//            }
//        }
//    }
    
    func fetchExternalUserFeedPosts(userId: String, completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("users").child(userId).child("feedPosts")
        ref.observeSingleEvent(of: .value) { snapshot in
            var fetchedPosts: [FeedPost] = []
            if let feedPostDict = snapshot.value as? [String: Any] {
                for (_, postData) in feedPostDict {
                    if let postDataDict = postData as? [String: Any],
                       let postDataJson = try? JSONSerialization.data(withJSONObject: postDataDict),
                       let feedPost = try? JSONDecoder().decode(FeedPost.self, from: postDataJson) {
                        fetchedPosts.append(feedPost)
                    }
                }
            }
            DispatchQueue.main.async {
                self.externalUserPosts = fetchedPosts.sorted { $0.timestamp > $1.timestamp }
                completion()
            }
        }
    }



    private func processFeedPosts(feedPostDict: [String: Any]) {
        var tempFeedPosts = [FeedPost]()
        for (postId, postData) in feedPostDict {
            if let postDataDict = postData as? [String: Any],
               let postDataJson = try? JSONSerialization.data(withJSONObject: postDataDict) {
                do {
                    let feedPost = try JSONDecoder().decode(FeedPost.self, from: postDataJson)
                    tempFeedPosts.append(feedPost)
                } catch {
                    print("DEBUG: Error decoding post \(postId): \(error)")
                }
            }
        }
        DispatchQueue.main.async {
            // Append the fetched feed posts to the existing feedPosts array
            self.feedPosts.append(contentsOf: tempFeedPosts.sorted { $0.timestamp > $1.timestamp })
        }
    }
    
    
    private func updateFeedPost(postId: String, post: FeedPost) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        // ... code to update the post in Firebase ...
    }
    
    func likePost(postId: String) {
        guard let userID = currentUserId else { return }
        
        let postRef = Database.database().reference().child("posts").child(postId).child("likes").child(userID)
        postRef.setValue(true) { error, _ in
            if let error = error {
                print("Error setting like: \(error.localizedDescription)")
            } else {
                self.updateLocalPostLikeStatus(postId: postId, liked: true)
            }
        }
    }

    func unlikePost(postId: String) {
        guard let userID = currentUserId else { return }
        
        let postRef = Database.database().reference().child("posts").child(postId).child("likes").child(userID)
        postRef.removeValue { error, _ in
            if let error = error {
                print("Error removing like: \(error.localizedDescription)")
            } else {
                self.updateLocalPostLikeStatus(postId: postId, liked: false)
            }
        }
    }
    
    func toggleLike(for postId: String) {
        guard let userID = currentUserId else { return }
        guard let postIndex = feedPosts.firstIndex(where: { $0.id.uuidString == postId }) else { return }

        
        let postRef = Database.database().reference().child("posts").child(postId).child("likes").child(userID)
        
        if feedPosts[postIndex].isLikedByCurrentUser {
            // If the post is currently liked, unlike it
            postRef.removeValue { [weak self] error, _ in
                if let error = error {
                    print("Error removing like: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self?.feedPosts[postIndex].isLikedByCurrentUser = false
                    }
                }
            }
        } else {
            // If the post is not liked, like it
            postRef.setValue(true) { [weak self] error, _ in
                if let error = error {
                    print("Error setting like: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self?.feedPosts[postIndex].isLikedByCurrentUser = true
                    }
                }
            }
        }
    }
    
    
    private func updateFeedPost(postId: String, with values: [String: Any]) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let firebaseRef = Database.database().reference()
        let postRef = firebaseRef.child("users").child(userID).child("feedPosts").child(postId)
        
        postRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Error updating post: \(error.localizedDescription)")
            } else {
                // Optionally, you might want to fetch the updated posts here.
            }
        }
    }
    
    func addComment(to postId: String, comment: Comment) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let postIndex = feedPosts.firstIndex(where: { $0.id.uuidString == postId }) else { return }
        
        // First, append the comment to the local copy of the post
        if feedPosts[postIndex].comments == nil {
            feedPosts[postIndex].comments = []
        }
        feedPosts[postIndex].comments?.append(comment)
        
        // Prepare the comment data for Firebase
        let commentData = comment.dictionaryRepresentation
        let firebaseRef = Database.database().reference()
        let commentsRef = firebaseRef.child("users").child(userID).child("feedPosts").child(postId).child("comments")
        
        // Use childByAutoId() to add a new comment under the unique ID
        let newCommentRef = commentsRef.childByAutoId()
        newCommentRef.updateChildValues(commentData) { (error, ref) in
            if let error = error {
                print("Error adding comment: \(error.localizedDescription)")
            } else {
                // Optionally, you might want to fetch the updated posts here.
            }
        }
    }
    
//    func addComment(to postId: String, comment: Comment) {
//        // Assuming userID is the ID of the currently logged-in user
//        guard let userID = Auth.auth().currentUser?.uid else {
//            print("Authentication required to comment.")
//            return
//        }
//
//        // Prepare the comment data
//        let commentData: [String: Any] = [
//            "id": comment.id,
//            "text": comment.text,
//            "authorId": comment.authorId,
//            "timestamp": comment.timestamp.timeIntervalSince1970
//        ]
//
//        // Reference to the specific post's comments in the database
//        let commentsRef = Database.database().reference().child("feedPosts").child(postId).child("comments")
//
//        // Add the new comment
//        let newCommentRef = commentsRef.childByAutoId()
//        newCommentRef.setValue(commentData) { error, _ in
//            if let error = error {
//                print("Error adding comment: \(error.localizedDescription)")
//            } else {
//                print("Comment added successfully.")
//            }
//        }
//    }
    
    private func removeDuplicatesAndSort(posts: [FeedPost]) -> [FeedPost] {
        var seenIds = Set<UUID>()
        let uniquePosts = posts.filter { seenIds.insert($0.id).inserted }.sorted { $0.timestamp > $1.timestamp }
        return uniquePosts
    }
    
    private func appendCommentLocally(to postId: String, comment: Comment) {
        if let postIndex = fetchedFeedPosts.firstIndex(where: { $0.id.uuidString == postId }) {
            if fetchedFeedPosts[postIndex].comments == nil {
                fetchedFeedPosts[postIndex].comments = []
            }
            fetchedFeedPosts[postIndex].comments?.append(comment)
        }
    }
}


// Extend Comment to convert to a dictionary
// Adjust this based on the actual properties of Comment
extension Comment {
    var dictionaryRepresentation: [String: Any] {
        [
            "id": id,
            "text": text,
            "authorId": authorId,
            "timestamp": timestamp.timeIntervalSince1970
        ]
    }
}

