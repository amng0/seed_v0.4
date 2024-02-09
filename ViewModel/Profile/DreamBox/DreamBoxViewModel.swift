//
//  DreamBoxViewModel.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/4/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase
import SwiftUI
import FirebaseStorage

class DreamBoxViewModel: ObservableObject {
    
    @Published var dreams: [Dream] = []
    @Published var fetchedDreams: [Dream] = []
    @Published var uploadedImageURLs: [String] = []

    
    func setupAuth(dream: Dream) {
        // safely unwrap userID using firebase Auth
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        uploadDream(with: userID, dream: dream)
    }
    
    func addDream(dream: Dream) {
           guard let userID = Auth.auth().currentUser?.uid else { return }
           uploadDream(with: userID, dream: dream)
           fetchDreams()
       }
       
       func uploadDream(with uid: String, dream: Dream) {
           let firebaseRef = Database.database().reference()
           let dreamRef = firebaseRef.child("users").child(uid).child("dreams").child(dream.id)

           dreamRef.updateChildValues(dream.dictionaryRepresentation) { error, _ in
               if let error = error {
                   print("Error updating data: \(error.localizedDescription)")
               }
           }
       }
       
       func fetchDreams() {
           guard let userID = Auth.auth().currentUser?.uid else { return }
           let ref = Database.database().reference().child("users").child(userID).child("dreams")

           ref.observeSingleEvent(of: .value) { [weak self] snapshot in
               guard let self = self else { return }
               if let value = snapshot.value as? [String: [String: Any]] {
                   let dreams = value.map { key, value in
                       return Dream(id: key, description: value["description"] as? String ?? "", imageURL: value["imageURL"] as? String ?? "")
                   }
                   DispatchQueue.main.async {
                       self.dreams = dreams
                   }
               }
           }
       }
    
    
    
    func editDream(statId: UUID, with newDetails: Dream) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        let firebaseRef = Database.database().reference()
        let dreamRef = firebaseRef.child("users").child(userID).child("dreams").child("\(statId)")

        let updatedData = try? JSONEncoder().encode(newDetails)
        if let updatedData = updatedData, let jsonDict = try? JSONSerialization.jsonObject(with: updatedData, options: []) as? [String: Any] {
            dreamRef.updateChildValues(jsonDict) { [weak self] (error, ref) in
                if let error = error {
                    print("Error updating dream data: \(error.localizedDescription)")
                } else {
                    self?.fetchDreams() // Fetch updated stats
                }
            }
        }
    }
    
    func uploadPhoto(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
            print("Error: Could not convert image to JPEG data")
            completion(nil)
            return
        }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("dream_images").child(filename)

        print("Uploading photo with filename: \(filename)")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading photo: \(error.localizedDescription)")
                completion(nil)
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                }
                completion(url?.absoluteString)
            }
        }
    }



    
    func deleteStat(statId: UUID) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        let firebaseRef = Database.database().reference()
        let dreamRef = firebaseRef.child("users").child(userID).child("stats").child("\(statId)")

        dreamRef.removeValue { error, _ in
            if let error = error {
                print("Error deleting dream: \(error.localizedDescription)")
            } else {
                // Handle successful deletion, e.g., update UI, notify user, etc.
                self.fetchedDreams // Optionally refresh goal posts after deletion
            }
        }
    }
}
