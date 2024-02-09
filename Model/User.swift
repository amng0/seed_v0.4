//
//  User.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 7/27/23.
//

import Firebase

struct User: Codable {
    var firstName: String
    var lastName: String
    let email: String
    var username: String
    var profileImageUrl: URL?
    let uid: String
    var bio: String?
    var isFollowed = false
    var friends: Int = 0
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    // Define CodingKeys
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, email, username, profileImageUrl, uid, bio, isFollowed, friends
    }
    
    // Custom initializer
    init(fromSessionUser sessionUser: SessionUserDetails, uid: String, profileImageUrl: URL? = nil, bio: String? = nil, isFollowed: Bool = false, friends: Int = 0) {
        self.firstName = sessionUser.firstName
        self.lastName = sessionUser.lastName
        self.email = sessionUser.email
        self.username = sessionUser.username
        self.profileImageUrl = profileImageUrl
        self.uid = uid
        self.bio = bio
        self.isFollowed = isFollowed
        self.friends = friends
    }

    // Codable initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.email = try container.decode(String.self, forKey: .email)
        self.username = try container.decode(String.self, forKey: .username)
        self.profileImageUrl = try container.decodeIfPresent(URL.self, forKey: .profileImageUrl)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
        self.isFollowed = try container.decodeIfPresent(Bool.self, forKey: .isFollowed) ?? false
        self.friends = try container.decodeIfPresent(Int.self, forKey: .friends) ?? 0
    }

    // Encoder function
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(username, forKey: .username)
        try container.encodeIfPresent(profileImageUrl, forKey: .profileImageUrl)
        try container.encode(uid, forKey: .uid)
        try container.encodeIfPresent(bio, forKey: .bio)
        try container.encode(isFollowed, forKey: .isFollowed)
        try container.encodeIfPresent(friends, forKey: .friends)
    }
}
