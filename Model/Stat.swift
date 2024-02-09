//
//  Stat.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 10/16/23.
//
import Firebase

struct Stat: Codable, Identifiable {
    var id = UUID()
    var title: String
    var value: String
    var goalType: String

    var dictionaryRepresentation: [String: Any] {
        return ["id": id, "title": title, "value": value, "goalType": goalType]
    }
}
