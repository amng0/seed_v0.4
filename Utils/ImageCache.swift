////
////  ImageCache.swift
////  seed_v0.4
////
////  Created by Amie Nguyen on 2/3/24.
////
//
//import Foundation
//import SwiftUI
//
//class ImageCache {
//    static let shared = NSCache<NSURL, UIImage>()
//}
//
//extension Image {
//    static func cachedAsyncImage(url: URL) -> some View {
//        if let image = ImageCache.shared.object(forKey: url as NSURL) {
//            return Image(uiImage: image).resizable()
//        } else {
//            return AsyncImage(url: url) { image in
//                image.resizable()
//            } placeholder: {
//                ProgressView()
//            }
//            .onAppear {
//                // Load the image and cache it
//                loadImageAndCache(from: url)
//            }
//        }
//    }
//    
//    private static func loadImageAndCache(from url: URL) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, let image = UIImage(data: data) else { return }
//            ImageCache.shared.setObject(image, forKey: url as NSURL)
//        }.resume()
//    }
//}
