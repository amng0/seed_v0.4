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
        guard let currentUser = Auth.auth().currentUser else {
            print("No logged-in user.")
            return
        }
        let firebaseRef = Database.database().reference()
        let data = try? JSONEncoder().encode(feedPost)
        
        if let data = data, let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            let userRef = Database.database().reference().child("users").child(currentUser.uid)
            let feedPostRef = userRef.child("feedPosts3").child("\(feedPost.id)")
            
            feedPostRef.updateChildValues(jsonDict) { (error, ref) in
                if let error = error {
                    print("Error updating board data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: Fetching Feed Post Functions
    
    func fetchFeedPosts(completion: @escaping () -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("DEBUG: User ID is nil")
            return
        }
        
        let ref = Database.database().reference().child("users").child(userID).child("goalPosts")
        print("DEBUG: Fetching feed posts from Firebase path: \(ref)")
        
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            if !snapshot.exists() {
                print("DEBUG: Snapshot does not exist")
                DispatchQueue.main.async {
                    self.feedPosts = []
                    completion()
                }
                return
            }
            
            guard let feedPostDict = snapshot.value as? [String: Any] else {
                print("DEBUG: Snapshot value is not a valid dictionary")
                DispatchQueue.main.async {
                    completion() // Also call completion here if the data is not in the expected format
                }
                return
            }
            
            print("DEBUG: Retrieved feed posts dictionary: \(feedPostDict)")
            
            do {
                var tempFeedPosts = [FeedPost]()
                for (postId, postData) in feedPostDict {
                    print("DEBUG: Processing post with ID: \(postId)")
                    if let postDataDict = postData as? [String: Any],
                       let postDataJson = try? JSONSerialization.data(withJSONObject: postDataDict) {
                        do {
                            let feedPost = try JSONDecoder().decode(FeedPost.self, from: postDataJson)
                            tempFeedPosts.append(feedPost)
                        } catch {
                            print("DEBUG: Error decoding post \(postId): \(error)")
                        }
                    } else {
                        print("DEBUG: Invalid data format for post \(postId)")
                    }
                }
                DispatchQueue.main.async {
                    self.feedPosts = tempFeedPosts.sorted { $0.timestamp > $1.timestamp }
                    completion()
                }
            } catch {
                print("DEBUG: Error decoding feed posts: \(error)")
            }
        }
    }

    
//    func fetchFeedPostsFromFollowingUsers(completion: @escaping () -> Void) {
//        guard let currentUserUID = Auth.auth().currentUser?.uid else {
//            // Handle the case when the current user is not authenticated
//            print("DEBUG: Current user is not authenticated.")
//            return
//        }
//
//        // Reference to the logged-in user's following node
//        let loggedInUserFollowingRef = Database.database().reference().child("users").child(currentUserUID).child("following")
//
//        loggedInUserFollowingRef.observeSingleEvent(of: .value) { [weak self] snapshot in
//            guard let self = self else { return }
//
//            if snapshot.exists() {
//                // Expecting the following node to be a dictionary with UIDs as keys
//                if let followingDict = snapshot.value as? [String: Bool] {
//                    let followingUIDs = followingDict.keys
//                    print("DEBUG: Found following UIDs: \(followingUIDs)")
//
//                    // Create a dispatch group to handle multiple asynchronous calls
//                    let dispatchGroup = DispatchGroup()
//
//                    for followingUID in followingUIDs {
//                        print("DEBUG: Fetching feed posts for user with UID: \(followingUID)")
//
//                        // Enter the dispatch group before making the fetchExternalUserPosts call
//                        dispatchGroup.enter()
//
//                        // Fetch feed posts for each user the current user is following
//                        self.fetchExternalUserFeedPosts(userId: followingUID) {
//                            // Leave the dispatch group when the fetchExternalUserPosts call is complete
//                            dispatchGroup.leave()
//                        }
//                    }
//
//                    // Notify when all fetchExternalUserPosts calls are complete
//                    dispatchGroup.notify(queue: .main) {
//                        // Apply deduplication and sorting after all posts are fetched
//                        self.feedPosts = self.removeDuplicatesAndSort(posts: self.feedPosts)
//                        print("DEBUG: All fetchExternalUserPosts calls are complete. Feed posts deduplicated and sorted.")
//                        completion() // Call the completion handler here, after all operations are complete.
//                        print("Feed posts updated with \(self.feedPosts.count) posts.")
//
//                    }
//                } else {
//                    print("DEBUG: Following UIDs not in the expected format.")
//                    completion() // Call completion here if the format isn't as expected.
//                }
//            } else {
//                print("DEBUG: No following UIDs found.")
//                completion() // Call completion here if no following UIDs are found.
//            }
//        }
//    }

    
    func fetchPostsForLoggedInUser(completion: @escaping () -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No logged-in user.")
            return
        }
        print("Debug: Fetching posts for user ID \(currentUser)")

        // Adjusted reference to the logged-in user's posts in feedPosts2 node
        let userPostsRef = Database.database().reference().child("users").child(currentUser.uid).child("feedPosts3")
        userPostsRef.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let self = self else { return }

            // Clear existing posts to avoid duplication
            self.feedPosts.removeAll()

            if !snapshot.exists() {
                print("Debug: No posts found for the logged-in user.")
                DispatchQueue.main.async {
                    completion()
                }
                return
            }

            guard let postsDict = snapshot.value as? [String: Any] else {
                print("Debug: Snapshot is not in the expected format.")
                DispatchQueue.main.async {
                    completion()
                }
                return
            }

            print("Debug: Found \(postsDict.count) posts for the logged-in user.")

            var tempFeedPosts: [FeedPost] = []
            for (postID, postData) in postsDict {
                if let postDataDict = postData as? [String: Any],
                   let postDataJson = try? JSONSerialization.data(withJSONObject: postDataDict),
                   let feedPost = try? JSONDecoder().decode(FeedPost.self, from: postDataJson) {
                    tempFeedPosts.append(feedPost)
                    print("Debug: Successfully decoded post with ID \(postID).")
                } else {
                    print("Debug: Failed to decode post with ID \(postID).")
                }
            }

            DispatchQueue.main.async {
                self.feedPosts = tempFeedPosts.sorted { $0.timestamp > $1.timestamp }
                print("Debug: Posts array updated. Total posts: \(self.feedPosts.count)")
                completion()
            }
        }) { error in
            print("Debug: Error fetching posts - \(error.localizedDescription)")
        }
    }
    
    func fetchFeedPostsFromFollowingUsers(completion: @escaping () -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            // Handle the case when the current user is not authenticated
            print("DEBUG: Current user is not authenticated.")
            completion()
            return
        }

        let loggedInUserFollowingRef = Database.database().reference().child("users").child(currentUserUID).child("following")
        
        loggedInUserFollowingRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }

            if let followingDict = snapshot.value as? [String: Bool] {
                let followingUIDs = followingDict.keys
                
                if followingUIDs.isEmpty {
                    // Immediately call completion if there are no users to fetch posts from
                    DispatchQueue.main.async {
                        completion()
                    }
                    return
                }

                let dispatchGroup = DispatchGroup()
                var allFetchedPosts: [FeedPost] = [] // Accumulate all posts here
                
                for followingUID in followingUIDs {
                    dispatchGroup.enter()
                    
                    self.fetchExternalUserFeedPosts(userId: followingUID) { fetchedPosts in
                        allFetchedPosts.append(contentsOf: fetchedPosts) // Aggregate fetched posts
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    // Apply deduplication and sorting after all posts are fetched
                    self.feedPosts = self.removeDuplicatesAndSort(posts: allFetchedPosts)
                    print("DEBUG: All fetchExternalUserPosts calls are complete. Feed posts deduplicated and sorted.")
                    completion() // Call the completion handler here, after all operations are complete.
                }
            } else {
                print("DEBUG: No following UIDs found or not in expected format.")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }

    func fetchExternalUserFeedPosts(userId: String, completion: @escaping ([FeedPost]) -> Void) {
        let ref = Database.database().reference().child("users").child(userId).child("feedPosts3")
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
            completion(fetchedPosts) // Return the fetched posts via the completion handler
        }
    }


    
//Properly funcitoning but commented out for FeedView following testing
//    func fetchExternalUserFeedPosts(userId: String, completion: @escaping () -> Void) {
//        let ref = Database.database().reference().child("users").child(userId).child("feedPosts3")
//        ref.observeSingleEvent(of: .value) { snapshot in
//            var fetchedPosts: [FeedPost] = []
//            if let feedPostDict = snapshot.value as? [String: Any] {
//                for (_, postData) in feedPostDict {
//                    if let postDataDict = postData as? [String: Any],
//                       let postDataJson = try? JSONSerialization.data(withJSONObject: postDataDict),
//                       let feedPost = try? JSONDecoder().decode(FeedPost.self, from: postDataJson) {
//                        fetchedPosts.append(feedPost)
//                    }
//                }
//            }
//            DispatchQueue.main.async {
//                self.externalUserPosts = fetchedPosts.sorted { $0.timestamp > $1.timestamp }
//                completion()
//            }
//        }
//    }
    
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
    
    // MARK: Feed Post Interactions
    
    private func updateFeedPost(postId: String, post: FeedPost) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        // ... code to update the post in Firebase ...
    }
    
    func likePost(postId: String) {
        guard let userID = currentUserId else { return }
        
        let postRef = Database.database().reference()
            .child("feedPosts3")
            .child(postId)
            .child("comments")
            .childByAutoId()
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
        
        let postRef = Database.database().reference()
            .child("feedPosts3")
            .child(postId)
            .child("comments")
            .childByAutoId()
        postRef.removeValue { error, _ in
            if let error = error {
                print("Error removing like: \(error.localizedDescription)")
            } else {
                self.updateLocalPostLikeStatus(postId: postId, liked: false)
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
    
    
    func toggleLike(for postId: String) {
        guard let userID = currentUserId else { return }
        guard let postIndex = feedPosts.firstIndex(where: { $0.id.uuidString == postId }) else { return }

        
        let postRef = Database.database().reference()
            .child("feedPosts3")
            .child(postId)
            .child("likes")
            .childByAutoId()
        
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
        let postRef = firebaseRef.child("users").child(userID).child("feedPosts3").child(postId)
        
        postRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Error updating post: \(error.localizedDescription)")
            } else {
                // Optionally, you might want to fetch the updated posts here.
            }
        }
    }
    
    func addComment(to postId: String, comment: Comment, completion: @escaping () -> Void) {
        guard let _ = Auth.auth().currentUser?.uid else { return }
        
        let commentsRef = Database.database().reference()
            .child("feedPosts3")
            .child(postId)
            .child("comments")
            .childByAutoId()
        let commentData = comment.dictionaryRepresentation
        
        commentsRef.setValue(commentData) { [weak self] error, _ in
            if let error = error {
                print("Error adding comment: \(error.localizedDescription)")
            } else {
                // Fetch the latest comments including the new one and call completion handler
                self?.fetchComments(forPost: postId) { comments in
                    DispatchQueue.main.async {
                        if let index = self?.feedPosts.firstIndex(where: { $0.id.uuidString == postId }) {
                            self?.feedPosts[index].comments = comments
                            completion()
                        }
                    }
                }
            }
        }
    }

    func fetchComments(forPost postId: String, completion: @escaping ([Comment]) -> Void) {
        let commentsRef = Database.database().reference().child("feedPosts3").child(postId).child("comments")
        commentsRef.observeSingleEvent(of: .value) { snapshot in
            var comments = [Comment]()

            for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                guard let commentDict = child.value as? [String: Any],
                      let comment = Comment(dictionary: commentDict) else { continue }
                comments.append(comment)
            }

            DispatchQueue.main.async {
                completion(comments)
            }
        }
    }

    
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

