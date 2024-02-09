//
//  GoalPost.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 7/28/23.
//

import Firebase

class GoalPost: ObservableObject, Identifiable, Codable {
    var id = UUID()
    var caption: String
    let uid: String
    var likes: Int
    var timestamp: Date?
    var category: GoalType
    var completeBy: Date
    var endGoal: String
    let user: SessionUserDetails
    var didLike = false
    var trackingPeriod: TrackingPeriod
    var incrementValue: String
    @Published var currentProgress: String
    @Published var status: GoalStatus = .active // The new status property
    
    enum CodingKeys: String, CodingKey {
        case id, caption, uid, likes, timestamp, category, completeBy, endGoal, user, didLike, trackingPeriod, currentProgress, incrementValue, status
    }
    
    init(caption: String, uid: String, likes: Int = 0, category: GoalType, completeBy: Date, endGoal: String, user: SessionUserDetails, trackingPeriod: TrackingPeriod, currentProgress: String, incrementValue: String, status: GoalStatus = .active) {
        self.caption = caption
        self.uid = uid
        self.likes = likes
        self.timestamp = Date()
        self.category = category
        self.completeBy = completeBy
        self.endGoal = endGoal
        self.user = user
        self.trackingPeriod = trackingPeriod
        self.currentProgress = currentProgress
        self.incrementValue = incrementValue
        self.status = status
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        caption = try container.decode(String.self, forKey: .caption)
        uid = try container.decode(String.self, forKey: .uid)
        likes = try container.decode(Int.self, forKey: .likes)
        timestamp = try container.decodeIfPresent(Date.self, forKey: .timestamp)
        category = try container.decode(GoalType.self, forKey: .category)
        completeBy = try container.decode(Date.self, forKey: .completeBy)
        endGoal = try container.decode(String.self, forKey: .endGoal)
        user = try container.decode(SessionUserDetails.self, forKey: .user)
        didLike = try container.decode(Bool.self, forKey: .didLike)
        trackingPeriod = try container.decode(TrackingPeriod.self, forKey: .trackingPeriod)
        incrementValue = try container.decodeIfPresent(String.self, forKey: .incrementValue) ?? "1"
        currentProgress = try container.decode(String.self, forKey: .currentProgress)
        status = try container.decodeIfPresent(GoalStatus.self, forKey: .status) ?? .active
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(caption, forKey: .caption)
        try container.encode(uid, forKey: .uid)
        try container.encode(likes, forKey: .likes)
        try container.encodeIfPresent(timestamp, forKey: .timestamp)
        try container.encode(category, forKey: .category)
        try container.encode(completeBy, forKey: .completeBy)
        try container.encode(endGoal, forKey: .endGoal)
        try container.encode(user, forKey: .user)
        try container.encode(didLike, forKey: .didLike)
        try container.encode(trackingPeriod, forKey: .trackingPeriod)
        try container.encode(incrementValue, forKey: .incrementValue)
        try container.encode(currentProgress, forKey: .currentProgress)
        try container.encode(status, forKey: .status)
    }
}
