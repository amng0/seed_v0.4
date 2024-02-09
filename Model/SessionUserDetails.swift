//
//  SessionUserDetails.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 12/10/23.
//

struct SessionUserDetails: Codable {
    var uid: String  // Add the uid property
    var email: String
    var firstName: String
    var lastName: String
    var username: String
    var profileImageUrl: String
    var friendCount: Int? = 0
    var bio: String? = ""
    var isFollowing: Bool? = false
    var following: [String]?

    enum CodingKeys: String, CodingKey {
        case uid  // Include uid in CodingKeys
        case email
        case firstName
        case lastName
        case username
        case profileImageUrl
        case friendCount
        case bio
        case isFollowing
        case following
    }

    init?(dictionary: [String: Any]) {
        guard let uid = dictionary["uid"] as? String,
              let email = dictionary["email"] as? String,
              let firstName = dictionary["firstName"] as? String,
              let lastName = dictionary["lastName"] as? String,
              let username = dictionary["username"] as? String,
              let profileImageUrl = dictionary["profileImageUrl"] as? String else {
            return nil
        }

        self.uid = uid  // Initialize the uid property
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.profileImageUrl = profileImageUrl

        // Initialize the optional properties
        self.friendCount = dictionary["friendCount"] as? Int
        self.bio = dictionary["bio"] as? String
        self.isFollowing = dictionary["isFollowing"] as? Bool
        self.following = dictionary["following"] as? [String]
    }
    
    init(uid: String, email: String, firstName: String, lastName: String, username: String, profileImageUrl: String, friendCount: Int?, bio: String?, isFollowing: Bool?, following: [String]) {
        self.uid = uid
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.friendCount = friendCount
        self.bio = bio
        self.isFollowing = isFollowing
        self.following = following ?? [] // Use the empty array as a default value if `following` is nil
    }



    // You might need to adjust the custom init(from:) and encode(to:) to handle the new optional properties
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        username = try container.decode(String.self, forKey: .username)
        profileImageUrl = try container.decode(String.self, forKey: .profileImageUrl)
        friendCount = try container.decodeIfPresent(Int.self, forKey: .friendCount)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        isFollowing = try container.decodeIfPresent(Bool.self, forKey: .isFollowing)
        following = try container.decodeIfPresent([String].self, forKey: .following)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(email, forKey: .email)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(username, forKey: .username)
        try container.encode(profileImageUrl, forKey: .profileImageUrl)
        try container.encodeIfPresent(friendCount, forKey: .friendCount)
        try container.encodeIfPresent(bio, forKey: .bio)
        try container.encodeIfPresent(isFollowing, forKey: .isFollowing)
        try container.encodeIfPresent(following, forKey: .following)
    }
}
