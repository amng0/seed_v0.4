//
//  UserRegistrationInfo.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 12/10/23.
//

import Foundation
// All the data that will be written to Firebase RealTime Database, except the password. This is handled with Firebase Authentication.
struct UserRegistrationInfo {
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    var username: String
    
}
