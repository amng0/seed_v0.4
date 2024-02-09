//
//  ActiveGoalViewModel.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 10/16/23.
//

import Foundation

struct ActiveGoalViewModel {
    
    let activeGoal: GoalPost
    let user: User
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var usernameText: String{
        return "@\(user.username)"
    }
    
    init(activeGoal: GoalPost, user: User) {
        self.activeGoal = activeGoal
        self.user = user
    }
    
    var goalCaption: String {
        return activeGoal.caption
    }
    
    var endGoalText: String {
        return activeGoal.endGoal
    }
    
    var likesCount: Int {
        return activeGoal.likes
    }
    
    var goalCategory: GoalType {
        return activeGoal.category
    }
    
    var goalCompletionDate: Date {
        return activeGoal.completeBy
    }
    
    var isGoalLikedByUser: Bool {
        return activeGoal.didLike
    }
    
}
