//
//  StatPostService.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 10/16/23.
//

//import Firebase
//
//struct StatPostService{
//    static let shared = StatPostService()
//    
//    func uploadStat(title: String, value: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        
//        // Use goalType.rawValue to store the enum's underlying string value.
//        var values = ["title": title,
//                      "value": value,
//                      "uid": uid
//        ]
//        
//        let ref = REF_USER_STATS.child(uid).childByAutoId()
//        ref.updateChildValues(values, withCompletionBlock: completion)
//        
//    }
//}
        
    
//    func fetchGoalPosts(completion: @escaping([GoalPost]) -> Void) {
//        var goalPosts = [GoalPost]()
//
//        REF_GOALPOSTS.observe(.childAdded) { snapshot  in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            guard let uid = dictionary["uid"] as? String else { return }
//            guard let goalTypeString = dictionary["goalType"] as? String else {return}
//            let goalPostID = snapshot.key
//
//            UserService.shared.fetchUser(uid: uid) { user in
//                let goalPost = GoalPost(goalPostID: goalPostID, user: user, dictionary: dictionary)
//                goalPosts.append(goalPost)
//                completion(goalPosts)
//            }
//        }
//    }
