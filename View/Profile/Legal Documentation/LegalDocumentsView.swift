//
//  LegalDocumentsView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 2/2/24.
//

import SwiftUI

struct LegalDocumentsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PrivacyPolicyView()
                
//                SectionHeader(title: "Terms of Use")
//                Text("Outline the rules for using your app, including any restrictions or guidelines.")
//
                
//                SectionHeader(title: "Third-Party Licenses")
//                Text("Not applicable for Seed v1.0.")
                
                // Contact Information
                Text("Contact Information")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("For any questions or comments, contact us at nucleardesign1@gmail.com")
                    //.padding()
            }
            .padding(.horizontal)
        }
        .navigationBarTitle("Legal Documentation", displayMode: .inline)
    }
}


struct SectionTitle: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.title2)
            .fontWeight(.semibold)
            .padding(.vertical, 5)
    }
}

struct KeyPoint: View {
    var title: String
    var description: String
    
    init(_ title: String, _ description: String) {
        self.title = title
        self.description = description
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.bold)
            Text(description)
                .fixedSize(horizontal: false, vertical: true) // Ensures the text wraps correctly
        }.padding(.bottom, 5)
    }
}

struct BulletPoint: View {
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Text("•")
                .padding(.top, 5)
            Text(text)
                .fixedSize(horizontal: false, vertical: true) // Ensures the text wraps correctly
        }.padding(.leading, 5)
    }
}
