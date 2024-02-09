//
//  Comment.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/21/24.
//

import Foundation

struct Comment: Codable, Identifiable {
    let id: String
    let text: String
    let authorId: String
    let timestamp: Date
    // ... other properties ...
}
