//
//  DreamBoxView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 12/28/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct DreamBoxView: View {
    @StateObject private var viewModel = DreamBoxViewModel()
    @State private var showingPhotoPicker = false
    @State private var selectedPhotos: [UIImage] = []
    @State private var currentIndex = 0

    var body: some View {
        VStack {
            Spacer() // Use spacers to push content towards the middle
            
            Text("Your Dream Box")
                .font(.system(size: 24, weight: .bold)) // Adjust font size for smaller screens
                .padding()
                .frame(maxWidth: .infinity) // Ensure the title is centered
            
            TabView(selection: $currentIndex) {
                ForEach(viewModel.dreams.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        ZStack {
                            if let imageURL = viewModel.dreams[index].imageURL,
                               let url = URL(string: imageURL) {
                                WebImage(url: url)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width)
                                    .clipped()
                            } else {
                                Image("jojo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width)
                                    .clipped()
                            }
                            VStack(alignment: .leading) {
                                Spacer()
                                Text(viewModel.dreams[index].description)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                    .padding([.leading, .bottom, .trailing])
                            }
                            .background(LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.7)]), startPoint: .center, endPoint: .bottom))
                            .cornerRadius(20) // Rounded corners for gradient
                        }
                        .cornerRadius(25)
                        .shadow(radius: 10)
                        .padding(.horizontal)
                        .tag(index)
                    }
                    .frame(height: 300)
                    .padding(.vertical)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

            // Adjust the Add Photos button
            Button(action: {
                showingPhotoPicker = true
            }) {
                HStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.title2)
                    Text("Add Photos")
                        .fontWeight(.medium)
                }
                .padding()
                .foregroundColor(.blue)
                .background(Color.white) // Non-gradient background
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .padding(.bottom, 75) // Move the button up
            
            Spacer() // Balance the spacing at the bottom
        }
        .sheet(isPresented: $showingPhotoPicker) {
            PhotoPicker(selectedPhotos: $selectedPhotos)
        }
        .onChange(of: selectedPhotos) { newPhotos in
            print("New photos to upload: \(newPhotos.count)")
            for photo in newPhotos {
                viewModel.uploadPhoto(photo) { url in
                    print("Upload completed. URL: \(url ?? "nil")")
                }
            }
        }
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}



struct DreamBoxView_Previews: PreviewProvider {
    static var previews: some View {
        DreamBoxView()
    }
}


