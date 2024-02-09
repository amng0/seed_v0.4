//
//  EditProfileView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/20/24.
//

import SwiftUI

struct EditProfileView: View {
    

    var body: some View {
        Form {
            Section(header: Text("Profile Picture")) {
                // Add functionality to change profile picture
            }
            Section(header: Text("Banner")) {
                // Add functionality to change banner
            }
            Section(header: Text("Name")) {
//                TextField("First Name", text: $userDetails.firstName)
//                TextField("Last Name", text: $userDetails.lastName)
            }
            Section(header: Text("Bio")) {
//                TextField("First Name", text: $userDetails.firstName)
//                TextField("Last Name", text: $userDetails.lastName)
            }
            // Add more sections as needed
        }
        .navigationBarTitle("Edit Profile", displayMode: .inline)
    }
}
