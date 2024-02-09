//
//  Dream.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/6/24.
//

import SwiftUI
import Foundation

struct Dream: Codable, Identifiable {
    var id: String // ID as a string
    var description: String
    var imageURL: String

    init(id: String = UUID().uuidString, description: String, imageURL: String) {
        self.id = id
        self.description = description
        self.imageURL = imageURL
    }

    var dictionaryRepresentation: [String: Any] {
        return ["id": id, "description": description, "imageURL": imageURL]
    }
}



