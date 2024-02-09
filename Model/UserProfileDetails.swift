//
//  UserProfileDetails.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/30/24.
//

import SwiftUI

struct UserProfileDetails: Codable {
    var bio: String
    var friendsCount: Int
    var isFollowed: Bool
    // You can include a reference to SessionUserDetails if needed
    var sessionDetails: SessionUserDetails
}
