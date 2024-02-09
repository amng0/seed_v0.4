//
//  PhotoCardView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/4/24.
//

import SwiftUI
import UIKit

struct PhotoCardView: View {
    var photo: UIImage
    @State private var descriptionText: String = ""

    var body: some View {
        VStack {
            Image(uiImage: photo)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .cornerRadius(10)
                .padding()

            TextField("Describe your dream...", text: $descriptionText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .frame(width: 300, height: 400)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

