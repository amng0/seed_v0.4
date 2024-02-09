//
//  FeedPost.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/15/24.
//

import Foundation

class FeedPost: ObservableObject, Identifiable, Codable {
    var id = UUID()
    var goalPostId: UUID
    var userDetails: SessionUserDetails
    var caption: String?
    var likes: Int = 0
    var timestamp: Date
    @Published var isLikedByCurrentUser: Bool
    var comments: [Comment]?

    enum CodingKeys: String, CodingKey {
        case id, goalPostId, userDetails, caption, likes, timestamp, comments, isLikedByCurrentUser
    }

    init(goalPost: GoalPost, caption: String? = nil) {
        self.goalPostId = goalPost.id
        self.userDetails = goalPost.user
        self.caption = caption ?? "\(goalPost.user.firstName) has set a new goal: \(goalPost.caption)"
        self.timestamp = Date()
        self.comments = []
        self.isLikedByCurrentUser = false
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        goalPostId = try container.decode(UUID.self, forKey: .goalPostId)
        userDetails = try container.decode(SessionUserDetails.self, forKey: .userDetails)
        caption = try container.decode(String.self, forKey: .caption)
        likes = try container.decode(Int.self, forKey: .likes)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        if let commentsDict = try? container.decodeIfPresent([String: Comment].self, forKey: .comments) {
            comments = Array(commentsDict.values)
        } else {
            comments = nil
        }
        isLikedByCurrentUser = try container.decode(Bool.self, forKey: .isLikedByCurrentUser)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(goalPostId, forKey: .goalPostId)
        try container.encode(userDetails, forKey: .userDetails)
        try container.encode(caption, forKey: .caption)
        try container.encode(likes, forKey: .likes)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(comments, forKey: .comments)
        try container.encode(isLikedByCurrentUser, forKey: .isLikedByCurrentUser)
    }
}

