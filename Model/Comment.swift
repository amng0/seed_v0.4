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

    // Custom initializer to create a Comment instance from a dictionary
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let text = dictionary["text"] as? String,
              let authorId = dictionary["authorId"] as? String,
              let timestamp = dictionary["timestamp"] as? TimeInterval else {
            return nil // Return nil if any of the required properties are missing
        }
        
        self.id = id
        self.text = text
        self.authorId = authorId
        // Convert timestamp from TimeInterval (seconds since 1970) to Date
        self.timestamp = Date(timeIntervalSince1970: timestamp)
    }
}

