//
//  Notification.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 10/11/23.
//

import Foundation

enum NotificationType: Int{
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    var tweetID: String?
    var timestamp: Date!
    var user: User
    var tweet: GoalPost?
    var type:  NotificationType!
    
    init(user: User, dictionary: [String: AnyObject]){
        self.user = user
    
        
        if let tweetID = dictionary["tweetID"] as? String {
            self.tweetID = tweetID
        }
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
        
    }
}
