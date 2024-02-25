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
            
            let feedPostRef = firebaseRef.child("feedPosts2").child("\(feedPost.id)")
            
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

    func fetchFeedPostsFromFollowingUsers(completion: @escaping () -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("DEBUG: Current user is not authenticated.")
            return
        }

        print("DEBUG: Fetching feed posts from following users for user \(currentUserUID)")

        let loggedInUserFollowingRef = Database.database().reference().child("users").child(currentUserUID).child("following")

        loggedInUserFollowingRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }

            if snapshot.exists(), let followingDict = snapshot.value as? [String: Bool] {
                let followingUIDs = followingDict.keys

                if followingUIDs.isEmpty {
                    print("DEBUG: The user is not following anyone.")
                    completion()
                    return
                }

                print("DEBUG: Found \(followingUIDs.count) users that the current user is following.")

                let dispatchGroup = DispatchGroup()

                for followingUID in followingUIDs {
                    print("DEBUG: Fetching posts for user \(followingUID)")
                    dispatchGroup.enter()
                    let ref = Database.database().reference().child("users").child(followingUID).child("goalPosts")
                    ref.observeSingleEvent(of: .value) { snapshot in
                        if snapshot.exists() {
                            if let feedPostDict = snapshot.value as? [String: Any] {
                                print("DEBUG: Found posts for user \(followingUID)")
                                self.processFeedPosts(feedPostDict: feedPostDict)
                            } else {
                                print("DEBUG: Posts for user \(followingUID) are not in the expected format.")
                            }
                        } else {
                            print("DEBUG: No posts found for user \(followingUID)")
                        }
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    print("DEBUG: Finished fetching posts from all following users.")
                    self.feedPosts = self.removeDuplicatesAndSort(posts: self.feedPosts)
                    completion()
                }
            } else {
                print("DEBUG: The 'following' node is empty or does not exist for the current user.")
                completion()
            }
        }
    }



    func fetchExternalUserPosts(userId: String, completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("users").child(userId).child("feedPosts2")
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
    
    func fetchPostsForLoggedInUser(completion: @escaping () -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Debug: User not logged in")
            return
        }
        
        print("Debug: Fetching posts for user ID \(currentUserID)")
        
        // Reference to the logged-in user's posts node
        let userPostsRef = Database.database().reference().child("users").child(currentUserID).child("feedPosts2")
        
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



    func fetchExternalUserFeedPosts(userId: String, completion: @escaping () -> Void) {
        let ref = Database.database().reference().child("users").child(userId).child("feedPosts2")
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
        
        let postRef = Database.database().reference()
            .child("feedPosts2")
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
            .child("feedPosts2")
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
            .child("feedPosts2")
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
        let postRef = firebaseRef.child("users").child(userID).child("feedPosts2").child(postId)
        
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
            .child("feedPosts2")
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
        let commentsRef = Database.database().reference().child("feedPosts2").child(postId).child("comments")
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

