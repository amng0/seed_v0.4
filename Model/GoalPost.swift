//
//  GoalPost.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 7/28/23.
//

import Firebase

struct GoalPost {
    let caption: String
    let goalPostID: String
    var likes: Int
    var timestamp: Date!
    let category: String
    var completeBy: Date
    var endGoal: String
    let user: User
    var didLike = false
    
    init(goalPostID: String, user: User, dictionary: [String: Any]){
        self.goalPostID = goalPostID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.category = dictionary["category"] as? String ?? ""
        self.completeBy = dictionary["completeBy"] as? Date ?? Date()
        self.endGoal = dictionary["endGoal"] as? String ?? ""
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}


