////
////  GoalPostService.swift
////  seed_v0.4
////
////  Created by Amie Nguyen on 7/28/23.
////
//
//import Firebase
//
//struct GoalPostService{
//    static let shared = GoalPostService()
//
//    func uploadGoalPost(caption: String, goalType: GoalType, completeBy: Date?, endGoal: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//
//        // Use goalType.rawValue to store the enum's underlying string value.
//        var values = ["uid": uid,
//                      "timestamp": Int(NSDate().timeIntervalSince1970),
//                      "likes": 0,
//                      "repoops": 0,
//                      "caption": caption,
//                      "endGoal": endGoal,
//                      "goalType": goalType.rawValue] as [String: Any]
//
//        // If completionDate is available, convert it to a timestamp and add it to the values dictionary
//        if let completeBy = completeBy {
//            values["completeBy"] = Int(completeBy.timeIntervalSince1970)
//        }
//
//        let ref = REF_GOALPOSTS.childByAutoId()
//
//        ref.updateChildValues(values) { (err, ref) in
//            guard let goalPostID = ref.key else { return }
//            REF_USER_GOALPOSTS.child(uid).updateChildValues([goalPostID: 1], withCompletionBlock: completion)
//        }
//    }
//
//    func fetchGoalPosts(completion: @escaping ([GoalPost]) -> Void) {
//        var goalPosts = [GoalPost]()
//
//        REF_GOALPOSTS.observe(.childAdded) { snapshot in
//            guard let dictionary = snapshot.value as? [String: Any],
//                  let uid = dictionary["uid"] as? String else { return }
//
//            UserService.shared.fetchUser(uid: uid) { user in
//                print(uid)
//                do {
//                    // Create a new dictionary including the user
//                    var updatedDictionary = dictionary
//                    updatedDictionary["user"] = user
//
//                    let data = try JSONSerialization.data(withJSONObject: updatedDictionary)
//                    let goalPost = try JSONDecoder().decode(GoalPost.self, from: data)
//                    goalPosts.append(goalPost)
//                    completion(goalPosts)
//                } catch {
//                    print("Error decoding GoalPost: \(error)")
//                }
//            }
//        }
//    }
//}
//
//    /*
//    func fetchLikes(forUser user: User, completion: @escaping([GoalPost]) -> Void){
//        var goalPosts = [GoalPost]()
//
//        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
//            let goalPostID = snapshot.key
//            self.fetchGoalPost(withGoalPostID: goalPostID) { likedGoalPost in
//                var goalPost = likedGoalPost
//                goalPost.didLike = true
//                goalPosts.append(goalPost)
//                completion(goalPosts)
//            }
//        }
//    }*/
//
////    func likeGoalPost(goalPost: GoalPost, completion: @escaping(DatabaseCompletion)) {
////        guard let uid = Auth.auth().currentUser?.uid else { return }
////
////        let likes = goalPost.didLike ? goalPost.likes - 1 : goalPost.likes + 1
////        REF_GOALPOSTS.child(goalPost.goalPostID).child("likes").setValue(likes)
////
////        if goalPost.didLike {
////            REF_USER_LIKES.child(uid).child(goalPost.goalPostID).removeValue { (err, ref) in
////                REF_GOALPOST_LIKES.child(goalPost.goalPostID).removeValue(completionBlock: completion)
////            }
////        } else {
////            REF_USER_LIKES.child(uid).updateChildValues([goalPost.goalPostID: 1]) { (err, ref) in
////                REF_GOALPOST_LIKES.child(goalPost.goalPostID).updateChildValues([uid: 1], withCompletionBlock: completion)
////            }
////        }
////    }
////
////    func checkIfUserLikedGoalPost(_ goalPost: GoalPost, completion: @escaping(Bool) -> Void){
////        guard let uid = Auth.auth().currentUser?.uid else { return }
////
////        REF_USER_LIKES.child(uid).child(goalPost.goalPostID).observeSingleEvent(of: .value) {snapshot in completion(snapshot.exists())
////        }
////        }
////    }
//
//
//
//
//
//
//
////        guard let currentUid = Auth.auth().currentUser?.uid else {return}
////
//////        REF_USER_FOLLOWING.child(currentUid).observe(.childAdded) { snapshot in
//////            let followingUid = snapshot.key
////
//////            REF_USER_GOALPOSTS.child(followingUid).observe(.childAdded) { snapshot in
//////                let goalPostID = snapshot.key
////
////                self.fetchGoalPosts(withGoalPostID: goalPostID) { goalPost in
////                    goalPosts.append(goalPost)
////                    completion(goalPosts)
////                }
////            }
////        }
////
////        REF_USER_GOALPOSTS.child(currentUid).observe(.childAdded){ snapshot in
////            let goalPostID = snapshot.key
////
////            self.fetchGoalPosts(withGoalPostID: goalPostID) { goalPost in
////                goalPosts.append(goalPost)
////                completion(goalPosts)
////            }
////        }
////    }
////
////
//
//
////    func fetchGoalPosts(completion: @escaping([GoalPost]) -> Void){
////        var goalPosts = [GoalPost]()
////
////        REF_USER_GOALPOSTS.observe(.childAdded) { snapshot  in
////            guard let dictionary = snapshot.value as? [String: Any] else { return }
////            guard let uid = dictionary["uid"] as? String else { return }
////
////            let goalPostID = snapshot.key
////
////            UserService.shared.fetchUser(uid: uid) { user in
////                let goalPost = GoalPost(goalPostID: goalPostID, user: user,   dictionary: dictionary)
////            //goalPosts.append(goalPost)
////            completion(goalPosts)
////            }
////        }
////    }
////
//
////
////
////
//
////}
////
